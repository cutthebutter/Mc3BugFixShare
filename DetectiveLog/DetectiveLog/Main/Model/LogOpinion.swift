//
//  LogOpinion.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/25.
//

import Foundation
import CloudKit

struct LogOpinion: Identifiable {
    let id: CKRecord.ID
    let referenceId: CKRecord.Reference
    let opinion: String
    let createdAt: Date
}
