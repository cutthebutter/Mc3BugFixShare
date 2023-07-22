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
                self.log = log
                print("@Log init - \(self.log)")
                print("@Log init - \(log)")
            }
        }
    }
    
    func changeLogCategory(category: LogCategory) {
        for i in 0..<logForCategoryChange.count {
            guard let changeIndex = log.firstIndex(where: { $0.id == logForCategoryChange[i].id }) else {
                return
            }
            log[changeIndex].category = category
            cloudKitManager.changeLogRecordCategory(log: log[changeIndex], category: category)
        }
    }
    
}
