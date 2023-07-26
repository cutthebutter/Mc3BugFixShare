//
//  CombineLogData.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/26.
//

import Foundation

struct CombineLogData: Identifiable, Equatable {
    
    static func == (lhs: CombineLogData, rhs: CombineLogData) -> Bool {
        return true
    }
    
    
    let id: UUID
    let date: Date
    var logMemo: [LogMemo] = []
    let logOpinion: LogOpinion?
}
