//
//  TempViewModel.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/24.
//

import Foundation

final class TempViewModel: ObservableObject {
    
    let cloudKitManager = CloudKitManager.shared
    @Published var tempLog: [Log] = []
    @Published var tempLogMemo: [LogMemo] = []
    @Published var tempLogOpinion: [LogOpinion] = []
    
    init() {
        fetchLog()
    }
    
    func fetchLog() {
        cloudKitManager.fetchLogRecord { log in
            DispatchQueue.main.async {
                self.tempLog = log
            }
        }
    }
    
    func fetchLogMemo(log: Log) {
//        cloudKitManager.fetchLogMemoRecord(log: log) { logMemo in
//            DispatchQueue.main.async {
//                self.tempLogMemo = logMemo
//                print("@Log1 - \(self.tempLogMemo)")
//            }
//        }
    }
    
    func fetchLogOpinion(log: Log) {
//        cloudKitManager.fetchLogOpinionRecord(log: log) { logOpinion in
//            DispatchQueue.main.async {
//                self.tempLogOpinion = logOpinion
//                print("@Log opinion init - \(self.tempLogOpinion)")
//            }
//        }
    }
    
    func createLogMemo(log: Log, text: String) {
        guard let logId = log.recordId else { return }
        let logMemo = LogMemo(id: UUID(),
                              recordId: nil,
                              referenceId: nil,
                              memo: text,
                              logMemoDate: Date(),
                              createdAt: Date())
        cloudKitManager.createLogMemoRecord(log: log, logMemo: logMemo)
        tempLogMemo.append(logMemo)
        var latestMemo: [String] = []
        
        let memoCount = min(tempLogMemo.count, 2)
        latestMemo = tempLogMemo.prefix(memoCount).map { $0.memo }
        
        cloudKitManager.updateLogRecord(log: log,
                                        latestMemo: latestMemo,
                                        updatedAt: Date())
    }
    
    func createLog(count: Int) {
        cloudKitManager.createLogRecord(log: Log(id: UUID(),
                                                 recordId: nil,
                                                 category: .inProgress,
                                                 title: "\(count)번째 사건일지",
                                                 latestMemo: nil,
                                                 isBookmarked: 0,
                                                 isLocked: 0,
                                                 isPinned: 0,
                                                 createdAt: Date(),
                                                 updatedAt: Date())) { recordId in
            
        }
    }
}
