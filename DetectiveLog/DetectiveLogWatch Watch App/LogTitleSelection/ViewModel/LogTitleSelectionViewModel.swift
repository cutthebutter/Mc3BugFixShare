//
//  LogTitleSelectionViewModel.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/24.
//

import Foundation

class LogTitleSelectionViewModel: ObservableObject {
    
    //TODO: 클라우드킷과 연결 필요함 : log를 불러와야 함
    
    @Published var fakeLog : [FakeLog] = []
    
    init() {
        fakeLog = [
        FakeLog(title: "가나"),
        FakeLog(title: "사나"),
        FakeLog(title: "다라")
        ]
        
    }
    
}
