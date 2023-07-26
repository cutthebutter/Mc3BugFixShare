//
//  SearchTestViewModel.swift
//  DetectiveLog
//
//  Created by semini on 2023/07/25.
//

import Foundation

class SearchTestViewModel : ObservableObject {
    @Published var logMemoList = [FakeLogMemo]()
    @Published var logCommentList = [FakeLogComment]()
    
    init() {
        logMemoList = (0..<300).map { _ in
            let n = Int.random(in: 1...10000)  // n 값을 랜덤으로 생성
            return FakeLogMemo(content: "로그 메모 \(n)", date: Date() - TimeInterval(3600 * n))
        }
        
        logMemoList.sort{ $0.date < $1.date }
        
        logCommentList = [
        FakeLogComment(comment: "사견 1", date: Date.now - TimeInterval(3600*70)),
        FakeLogComment(comment: "사견 2", date: Date.now - TimeInterval(3600*69)),
        FakeLogComment(comment: "사견 3", date: Date.now - TimeInterval(3600*48)),
        FakeLogComment(comment: "사견 4", date: Date.now - TimeInterval(3600*45)),
        FakeLogComment(comment: "사견 5", date: Date.now - TimeInterval(3600*43)),
        FakeLogComment(comment: "사견 6", date: Date.now - TimeInterval(3600*22)),
        FakeLogComment(comment: "사견 7", date: Date.now - TimeInterval(3600*20))
        
        ]
    }
    
    /// 로그메모에서 날짜만 추출
    func logMemoDates() -> [Date] {
        return Array(Set(logMemoList.map { $0.date }))
    }
    
}
