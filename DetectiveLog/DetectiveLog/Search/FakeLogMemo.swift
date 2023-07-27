//
//  FakeLogMemo.swift
//  DetectiveLog
//
//  Created by semini on 2023/07/25.
//

import Foundation
//코어데이터가 들어오면 대체할 모델
struct FakeLogMemo : Identifiable, Comparable {
    
    static func < (lhs: FakeLogMemo, rhs: FakeLogMemo) -> Bool {
        return lhs.date < rhs.date
    }
    
    let id : UUID
    var content : String
    let date : Date
    
    init(id : UUID = UUID(), content : String, date : Date = Date.now) {
        self.id = id
        self.content = content
        self.date = date
        
    }
}

struct FakeLogComment : Identifiable {
    let id : UUID
    var comment : String
    let date : Date
    
    init(id : UUID = UUID(), comment : String, date : Date = Date.now) {
        self.id = id
        self.comment = comment
        self.date = date
        
    }
}
