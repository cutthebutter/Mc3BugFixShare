//
//  LogList.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import Foundation
import CloudKit

struct LogList {
    let id: CKRecord.ID
    let category: LogCategory
    let title: String
    let latestMemo: [String]
    let isLocked: Bool
    let isPinned: Bool
    let createdAt: Date
    let updatedAt: Date
}

enum LogCategory: Int {
    case inProgress = 0
    case complete = 1
    case incomplete = 2
}
