//
//  LogRecordViewModel.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/30.
//

import Foundation

class LogRecordViewModel: ObservableObject {
    @Published var selectedLogList: [LogMemo] = []

    init(){

    }

//    func fetchLogMemo(selectedLog : Log) -> [LogMemo] {
//        cloudKitManager.fetchLogMemoRecord(log: selectedLog, { logMemo in
//            self.selectedLogList = logMemo
//        })
//        return selectedLogList
//    }
}
