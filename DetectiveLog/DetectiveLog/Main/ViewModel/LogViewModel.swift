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
    
    init() {
        fetchLog()
    }
    
    func fetchLog() {
        cloudKitManager.fetchLogRecord { log in
            DispatchQueue.main.async {
                self.log = log
                print("@Log init - \(self.log)")
            }
        }
    }
    
}
