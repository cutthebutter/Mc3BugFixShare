//
//  LogList.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import Foundation
import CloudKit

struct Log: Identifiable, Equatable{
    let id: UUID
    let recordId: CKRecord.ID?
    var category: LogCategory
    var title: String
    let latestMemo: [String]?
    let isBookmarked: Int // 0 == false <-> 1 == true
    var isLocked: Int
    var isPinned: Int
    let createdAt: Date
    let updatedAt: Date
}

enum LogCategory: Int {
    case inProgress = 0
    case complete = 1
    case incomplete = 2
}
