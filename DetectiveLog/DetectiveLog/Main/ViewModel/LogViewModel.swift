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
        for i in 0..<log.count {
            for j in 0..<logForCategoryChange.count {
                if log[i] == logForCategoryChange[j] {
                    log[i].category = category
                    
                }
            }
        }
        
        for i in 0..<logForCategoryChange.count {
            cloudKitManager.changeLogRecordCategory(log: logForCategoryChange[i], category: category)
        }
    }
    
}
