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
    @Published var logMemoDate = [Date]()
    
    init() {
        logMemoList =  [
            FakeLogMemo(content: "로그 메모 다람쥐 \(1)", date: Date() - TimeInterval(3600 * 20)),
            FakeLogMemo(content: "로그 메모 바다 \(1.1)", date: Date() - TimeInterval(3600 * 22)),
            FakeLogMemo(content: "로그 메모 다람쥐리\(2)", date: Date() - TimeInterval(3600 * 40)),
            FakeLogMemo(content: "로그 메모 고동 \(3)", date: Date() - TimeInterval(3600 * 60)),
            FakeLogMemo(content: "로그 메모 고라니 \(4)", date: Date() - TimeInterval(3600 * 80)),
            FakeLogMemo(content: "로그 메모 사슴 \(4.1)", date: Date() - TimeInterval(3600 * 82)),
            FakeLogMemo(content: "로그 메모 해달 \(7)", date: Date() - TimeInterval(3600 * 140)),
            FakeLogMemo(content: "로그 메모 수달 \(8)", date: Date() - TimeInterval(3600 * 160)),
            FakeLogMemo(content: "로그 메모 달수\(9)", date: Date() - TimeInterval(3600 * 180)),
            FakeLogMemo(content: "로그 메모 고진감래 \(9.1)", date: Date() - TimeInterval(3600 * 182)),
            FakeLogMemo(content: "로그 메모 사냥 \(9.2)", date: Date() - TimeInterval(3600 * 184)),
            FakeLogMemo(content: "로그 메모 고냥이 \(12)", date: Date() - TimeInterval(3600 * 240)),
            FakeLogMemo(content: "로그 메모 길냥이 \(13)", date: Date() - TimeInterval(3600 * 260)),
            FakeLogMemo(content: "로그 메모 강아지 \(14)", date: Date() - TimeInterval(3600 * 280)),
            FakeLogMemo(content: "로그 메모 멍멍이 \(14.1)", date: Date() - TimeInterval(3600 * 282)),
            FakeLogMemo(content: "로그 메모 강새이 \(14.2)", date: Date() - TimeInterval(3600 * 284)),
            FakeLogMemo(content: "로그 메모 고동 \(14.3)", date: Date() - TimeInterval(3600 * 286)),
            FakeLogMemo(content: "로그 메모 고등어 \(17)", date: Date() - TimeInterval(3600 * 340)),
            FakeLogMemo(content: "로그 메모 벌레 \(18)", date: Date() - TimeInterval(3600 * 360)),
            FakeLogMemo(content: "로그 메모 매미 \(19)", date: Date() - TimeInterval(3600 * 380)),
            FakeLogMemo(content: "로그 메모 배짱이 \(20)", date: Date() - TimeInterval(3600 * 400))
            
        ]
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
    var logMemoDates : [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let datesWithTime = logMemoList.map { $0.date }
        var datesWithoutTime = [String]()
        
        for date in datesWithTime {
            datesWithoutTime.append(dateFormatter.string(from: date))
        }
        return Array(Set(datesWithoutTime)).sorted{ $0 < $1 }
    }
}
