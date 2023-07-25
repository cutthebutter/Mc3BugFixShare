//
//  CombineLogData.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/26.
//

import Foundation

struct CombineLogData: Identifiable {
    let id: UUID
    let date: Date
    var logMemo: [LogMemo] = []
    let logOpinion: [LogOpinion]?
}
