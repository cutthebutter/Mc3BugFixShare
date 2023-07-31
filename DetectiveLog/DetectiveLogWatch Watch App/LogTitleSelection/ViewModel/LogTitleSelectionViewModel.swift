////
////  LogTitleSelectionViewModel.swift
////  DetectiveLogWatch Watch App
////
////  Created by semini on 2023/07/24.
////
//
//import Foundation
//
//class LogTitleSelectionViewModel: ObservableObject {
//    
//    let cloudKitManager = CloudKitManager.shared
//    
//    @Published var log : [Log] = []
//    
//    init() {
//        fetchLog()
//    }
//    
//    func fetchLog() {
//        cloudKitManager.fetchLogRecord { log in
//            DispatchQueue.main.async {
//                self.log = log.sorted(by: { $0.isPinned > $1.isPinned })
//            }
//        }
//    }
//
//    
//}
