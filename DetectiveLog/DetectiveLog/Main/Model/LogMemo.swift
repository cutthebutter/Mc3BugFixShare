//
//  LogList.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/24.
//

import Foundation
import CloudKit

struct LogMemo: Identifiable {
    let id: CKRecord.ID
    let referenceId: CKRecord.Reference?
    var memo: String
    let logMemoDate: Date
    var createdAt: Date
}
