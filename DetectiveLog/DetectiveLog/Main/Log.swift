//
//  LogList.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import Foundation
import CloudKit

struct Log {
    let id: CKRecord.ID
    let category: LogCategory
    let title: String
    let latestMemo: [String]
    let isBookmarked: Bool
    let isLocked: Bool
    let isPinned: Bool
    let createdAt: Date
    let updatedAt: Date
    let logMemoDates: [Date]
    let logMemoId: [CKRecord.ID]
}

enum LogCategory: Int {
    case inProgress = 0
    case complete = 1
    case incomplete = 2
}
