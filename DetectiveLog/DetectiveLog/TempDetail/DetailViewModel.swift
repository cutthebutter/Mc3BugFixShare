//
//  DetailViewModel.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/25.
//

import Foundation

final class DetailViewModel: ObservableObject {
    
    let cloudKitManager = CloudKitManager.shared
    let logCount: Int
    
    @Published var log: Log?
    @Published var logMemo: [Date: [LogMemo]] = [:]
    @Published var logOpinion: [Date: [LogOpinion]] = [:]
    @Published var combineLogData: [CombineLogData] = []
    
    
    init(log: Log?, logCount: Int) {
        self.log = log
        self.logCount = logCount
    }
    
    func fetchLogMemo(log: Log) {
        LogMemo.fetchLogMemoRecord(log: log) { logMemo in
            self.arrayToDictionary(convert: .logMemo,
                                   logMemo: logMemo,
                                   logOpinion: nil)
//            self.fetchLogOpinion(log: log)
        }
    }
    
    func fetchLogOpinion(log: Log) {
        LogOpinion.fetchLogOpinion(log: log) { logOpinion in
            self.arrayToDictionary(convert: .logOpinion,
                                   logMemo: nil,
                                   logOpinion: logOpinion)
        }
    }
    
    func createLog() {
        cloudKitManager.createLogRecord(log: Log(id: UUID(),
                                                 recordId: nil,
                                                 category: .inProgress,
                                                 title: "\(logCount)번째 사건일지",
                                                 latestMemo: nil,
                                                 isBookmarked: 0,
                                                 isLocked: 0,
                                                 isPinned: 0,
                                                 createdAt: Date(),
                                                 updatedAt: Date())) { [weak self] recordId in
            self?.cloudKitManager.fetchDetailLogRecord(id: recordId) { [weak self] log in
                DispatchQueue.main.async {
                    self?.log = log
                }
            }
        }
    }
    
//    func createLogMemo(log: Log, text: String) {
//        guard let logId = log.recordId else { return }
//        let logMemo = LogMemo(id: nil,
//                              referenceId: nil,
//                              memo: text,
//                              logMemoDate: Date(),
//                              createdAt: Date())
//        cloudKitManager.createLogMemoRecord(log: log, logMemo: logMemo)
//        tempLogMemo.append(logMemo)
//        var latestMemo: [String] = []
//
//        let memoCount = min(tempLogMemo.count, 2)
//        latestMemo = tempLogMemo.prefix(memoCount).map { $0.memo }
//
//        cloudKitManager.updateLogRecord(log: log,
//                                        latestMemo: latestMemo,
//                                        updatedAt: Date())
//    }
    
    func createLogMemo(log: Log, memo: String) {
        let logMemo = LogMemo(id: nil,
                              referenceId: nil,
                              memo: memo,
                              logMemoDate: Date(),
                              createdAt: Date())
        cloudKitManager.createLogMemoRecord(log: log, logMemo: logMemo)
        var latestMemo: [String] = []
        for i in 0..<combineLogData.count {
//            guard let logMemo = combineLogData[i].logMemo else { return }
            for j in 0..<combineLogData[i].logMemo.count {
                latestMemo.append(combineLogData[i].logMemo[j].memo)
            }
        }
        print("@Log memo latest - \(latestMemo)")
        cloudKitManager.updateLogRecord(log: log,
                                        latestMemo: latestMemo,
                                        updatedAt: Date())
        
        let today = Calendar.current.startOfDay(for: Date())

        if let index = combineLogData.firstIndex(where: { $0.date == today }) {
            // 이미 오늘 날짜와 같은 데이터가 있으면 해당 데이터에 logMemo를 추가합니다.
            combineLogData[index].logMemo.append(logMemo)
        } else {
            // 오늘 날짜와 같은 데이터가 없으면 새로운 CombineLogData를 생성하여 배열에 추가합니다.
            let newCombineLogData = CombineLogData(id: UUID(),
                                                   date: today,
                                                   logMemo: [logMemo],
                                                   logOpinion: nil)
            combineLogData.append(newCombineLogData)
        }
    }
    
    func arrayToDictionary(convert: LogConvert,
                           logMemo: [LogMemo]?,
                           logOpinion: [LogOpinion]?) {
        DispatchQueue.main.async {
            switch convert {
            case .logMemo:
                guard let logMemo = logMemo else { return }
                self.logMemo = Dictionary(grouping: logMemo) { memo in
                    return Calendar.current.startOfDay(for: memo.createdAt)
                }
            case .logOpinion:
                guard let logOpinion = logOpinion else { return }
                self.logOpinion = Dictionary(grouping: logOpinion) { opinion in
                    return Calendar.current.startOfDay(for: opinion.createdAt)
                }
            }
        }
    }
    
    func combineData() {
        let memoTuple = logMemo.sorted(by: { $0.key < $1.key })
        
        for (date, memos) in memoTuple {
            if let opinions = logOpinion[date] {
                print("@Log kozi - \(memos)")
                let memo = memos.sorted(by: { $0.createdAt < $1.createdAt })
                let data = CombineLogData(id: UUID(), date: date, logMemo: memo, logOpinion: opinions)
                combineLogData.append(data)
            } else {
                print("@Log kozi - \(memos)")
                let memo = memos.sorted(by: { $0.createdAt < $1.createdAt })
                let data = CombineLogData(id: UUID(), date: date, logMemo: memo, logOpinion: nil)
                combineLogData.append(data)
            }
        }
//        print("@Log combine - \(combineLogData)")
    }
    
}

enum LogConvert {
    case logMemo
    case logOpinion
}
