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
        logMemoList = [
            FakeLogMemo(content: "로그 메모 1", date: Date.now - TimeInterval(3600*72)),
            FakeLogMemo(content: "로그 메모 2", date: Date.now - TimeInterval(3600*71)),
            FakeLogMemo(content: "로그 메모 3", date: Date.now - TimeInterval(3600*70)),
            FakeLogMemo(content: "로그 메모 4", date: Date.now - TimeInterval(3600*48)),
            FakeLogMemo(content: "로그 메모 5", date: Date.now - TimeInterval(3600*47)),
            FakeLogMemo(content: "로그 메모 6", date: Date.now - TimeInterval(3600*46)),
            FakeLogMemo(content: "로그 메모 7", date: Date.now - TimeInterval(3600*24)),
            FakeLogMemo(content: "로그 메모 8", date: Date.now - TimeInterval(3600*23)),
            FakeLogMemo(content: "로그 메모 9", date: Date.now - TimeInterval(3600*22)),
            
        ]
        
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
}
