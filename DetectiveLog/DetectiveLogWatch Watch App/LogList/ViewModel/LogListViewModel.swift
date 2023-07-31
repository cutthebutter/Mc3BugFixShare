//
//  LogListViewModel.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/25.
//

import Foundation

class LogListViewModel: ObservableObject {
    
    
    @Published var fakeEachLog = [FakeEachLog]()
    //TODO: 클라우드킷 들어오면 바꿔야 할 곳 
    init() {
        fakeEachLog = [
            FakeEachLog(title: "가나", contents: "안녕하세요.클루입니다.", date: Date.now - TimeInterval(3600*24)),
            FakeEachLog(title: "다라", contents: "안녕하세요.클루입니다.2", date: Date.now - TimeInterval(3600*24)),
            FakeEachLog(title: "사나", contents: "안녕하세요.클루입니다.3", date: Date.now - TimeInterval(3600*48)),
        ]
    }
}
