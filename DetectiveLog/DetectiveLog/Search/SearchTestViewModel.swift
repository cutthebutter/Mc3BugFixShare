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
            FakeLogMemo(content: "로그 메모 \(1)", date: Date() - TimeInterval(3600 * 20)),
            FakeLogMemo(content: "로그 메모 \(1.1)", date: Date() - TimeInterval(3600 * 22)),
            FakeLogMemo(content: "로그 메모 \(2)", date: Date() - TimeInterval(3600 * 40)),
            FakeLogMemo(content: "로그 메모 \(3)", date: Date() - TimeInterval(3600 * 60)),
            FakeLogMemo(content: "로그 메모 \(4)", date: Date() - TimeInterval(3600 * 80)),
            FakeLogMemo(content: "로그 메모 \(4.1)", date: Date() - TimeInterval(3600 * 82)),
            FakeLogMemo(content: "로그 메모 \(7)", date: Date() - TimeInterval(3600 * 140)),
            FakeLogMemo(content: "로그 메모 \(8)", date: Date() - TimeInterval(3600 * 160)),
            FakeLogMemo(content: "로그 메모 \(9)", date: Date() - TimeInterval(3600 * 180)),
            FakeLogMemo(content: "로그 메모 \(9.1)", date: Date() - TimeInterval(3600 * 182)),
            FakeLogMemo(content: "로그 메모 \(9.2)", date: Date() - TimeInterval(3600 * 184)),
            FakeLogMemo(content: "로그 메모 \(12)", date: Date() - TimeInterval(3600 * 240)),
            FakeLogMemo(content: "로그 메모 \(13)", date: Date() - TimeInterval(3600 * 260)),
            FakeLogMemo(content: "로그 메모 \(14)", date: Date() - TimeInterval(3600 * 280)),
            FakeLogMemo(content: "로그 메모 \(14.1)", date: Date() - TimeInterval(3600 * 282)),
            FakeLogMemo(content: "로그 메모 \(14.2)", date: Date() - TimeInterval(3600 * 284)),
            FakeLogMemo(content: "로그 메모 \(14.3)", date: Date() - TimeInterval(3600 * 286)),
            FakeLogMemo(content: "로그 메모 \(17)", date: Date() - TimeInterval(3600 * 340)),
            FakeLogMemo(content: "로그 메모 \(18)", date: Date() - TimeInterval(3600 * 360)),
            FakeLogMemo(content: "로그 메모 \(19)", date: Date() - TimeInterval(3600 * 380)),
            FakeLogMemo(content: "로그 메모 \(20)", date: Date() - TimeInterval(3600 * 400))
            
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

//    var startYear : Int {
//        if let firstDate = logMemoList.first?.date {
//            return Calendar.current.component(.year, from: firstDate)
//        } else {
//            return Calendar.current.component(.year, from: Date())
//        }
//    }
//    
//    var startMonth : Int {
//        if let firstDate = logMemoList.first?.date {
//            return Calendar.current.component(.month, from: firstDate)
//        } else {
//            return Calendar.current.component(.month, from: Date())
//        }
//        
//    }
//    
//    var endYear : Int {
//        if let lastDate = logMemoList.last?.date {
//            return Calendar.current.component(.year, from: lastDate)
//        } else {
//            return Calendar.current.component(.year, from: Date())
//        }
//    }
//    
//    var endMonth : Int {
//        if let lastDate = logMemoList.first?.date {
//            return Calendar.current.component(.month, from: lastDate)
//        } else {
//            return Calendar.current.component(.month, from: Date())
//        }
//    }
//    
//    var allYears : [String] {
//        return Array(startYear...endYear).map { String(format: "%d년", $0) }
//    }
//    
//    var allMonths : [String] = Array(1...12).map { String(format: "%d월", $0) }
}
