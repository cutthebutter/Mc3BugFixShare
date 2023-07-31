//
//  LogViewModel.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/21.
//

import Foundation

final class LogViewModel: ObservableObject {
    
    let cloudKitManager = CloudKitManager.shared
    
    @Published var log: [Log] = []
    @Published var logForCategoryChange: [Log] = []
    
    init() {
        fetchLog()
    }
    
    func fetchLog() {
        cloudKitManager.fetchLogRecord { log in
            DispatchQueue.main.async {
                self.log = log.sorted(by: { $0.isPinned > $1.isPinned })
            }
        }
    }
    
    func changeLogCategory(category: LogCategory) {
        for i in 0..<logForCategoryChange.count {
            guard let changeIndex = log.firstIndex(where: { $0.id == logForCategoryChange[i].id }) else {
                return
            }
            log[changeIndex].category = category
            cloudKitManager.updateLogRecordCategory(log: log[changeIndex], category: category)
        }
    }
    
    func setPinned(selectedLog: Log, isPinned: Int) {
        guard let changeIndex = log.firstIndex(where: { $0.id == selectedLog.id }) else { return }
        cloudKitManager.updateLogRecordIsPinned(log: selectedLog,
                                                isPinned: isPinned == 0 ? 1 : 0)
        log[changeIndex].isPinned = isPinned == 0 ? 1 : 0
        
        // 시간순으로 먼저 정렬(내림차순-최신순)
        log.sort(by: { $0.createdAt > $1.createdAt })
        // 고정된 메모 상단으로 정렬(내림차순-최신순)
        log.sort { $0.isPinned > $1.isPinned }
    }
    
}
