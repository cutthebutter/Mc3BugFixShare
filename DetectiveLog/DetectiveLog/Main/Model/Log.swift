//
//  LogList.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import Foundation
import CloudKit

struct Log: Identifiable, Equatable {
    let id: CKRecord.ID?
    var category: LogCategory
    let title: String //사건명
    let latestMemo: [String]?
    let isBookmarked: Int // 0 == false <-> 1 == true
    let isLocked: Int
    var isPinned: Int
    let createdAt: Date
    let updatedAt: Date
    let logMemoDates: [Date]? // 데이터베이스에 저장된 날짜 불러오기 위함
    let logMemoId: [CKRecord.Reference]? // 연관 테이블, Id로 서로 연관됨
}

enum LogCategory: Int {
    case inProgress = 0
    case complete = 1
    case incomplete = 2
}
