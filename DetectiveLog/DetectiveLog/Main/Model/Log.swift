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

extension Log {
//    func toDictionary() -> [String: Any] {
//        return [
//            "id": id.uuidString,
//            "category": category.rawValue,
//            "title": title,
//            "latestMemo": latestMemo ?? [],
//            "isBookmarked": isBookmarked,
//            "isLocked": isLocked,
//            "isPinned": isPinned,
//            "createdAt": createdAt,
//            "updatedAt": updatedAt
//        ]
//    }
    
//    func toDictionary() -> [String: Any] {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let createdAtString = dateFormatter.string(from: createdAt)
//        let updatedAtString = dateFormatter.string(from: updatedAt)
//        return [
//            "id": id.uuidString,
//            "category": category.rawValue,
//            "title": title,
//            "latestMemo": latestMemo ?? [],
//            "isBookmarked": isBookmarked,
//            "isLocked": isLocked,
//            "isPinned": isPinned,
//            "createdAt": createdAtString,
//            "updatedAt": updatedAtString
//        ]
//    }
    
    func toDictionary() -> [String: Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let createdAtString = dateFormatter.string(from: createdAt)
        let updatedAtString = dateFormatter.string(from: updatedAt)
        return [
            "id": id.uuidString,
            "category": category.rawValue,
            "title": title,
            "latestMemo": latestMemo?.joined(separator: ",") ?? "",
            "isBookmarked": isBookmarked,
            "isLocked": isLocked,
            "isPinned": isPinned,
            "createdAt": createdAtString,
            "updatedAt": updatedAtString
        ]
    }
}

//extension Log {
//    init?(from dictionary: [String: Any]) {
//        guard let idString = dictionary["id"] as? String,
//              let id = UUID(uuidString: idString),
//              let categoryValue = dictionary["category"] as? Int,
//              let category = LogCategory(rawValue: categoryValue),
//              let title = dictionary["title"] as? String,
//              let createdAt = dictionary["createdAt"] as? Date,
//              let updatedAt = dictionary["updatedAt"] as? Date
//        else { return nil }
//
//        self.id = id
//        self.recordId = nil // CKRecord.ID는 딕셔너리에서 복원할 수 없으므로 별도 처리 필요
//        self.category = category
//        self.title = title
//        self.latestMemo = dictionary["latestMemo"] as? [String]
//        self.isBookmarked = dictionary["isBookmarked"] as? Int ?? 0
//        self.isLocked = dictionary["isLocked"] as? Int ?? 0
//        self.isPinned = dictionary["isPinned"] as? Int ?? 0
//        self.createdAt = createdAt
//        self.updatedAt = updatedAt
//    }
//}

//extension Log {
//    init?(from dictionary: [String: Any]) {
//        guard let idString = dictionary["id"] as? String,
//              let id = UUID(uuidString: idString),
//              let categoryValue = dictionary["category"] as? Int,
//              let category = LogCategory(rawValue: categoryValue),
//              let title = dictionary["title"] as? String,
//              let createdAtString = dictionary["createdAt"] as? String,
//              let updatedAtString = dictionary["updatedAt"] as? String
//        else { return nil }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        guard let createdAt = dateFormatter.date(from: createdAtString),
//              let updatedAt = dateFormatter.date(from: updatedAtString)
//        else { return nil }
//
//        self.id = id
//        self.recordId = nil
//        self.category = category
//        self.title = title
//        self.latestMemo = dictionary["latestMemo"] as? [String]
//        self.isBookmarked = dictionary["isBookmarked"] as? Int ?? 0
//        self.isLocked = dictionary["isLocked"] as? Int ?? 0
//        self.isPinned = dictionary["isPinned"] as? Int ?? 0
//        self.createdAt = createdAt
//        self.updatedAt = updatedAt
//    }
//}

extension Log {
    init?(from dictionary: [String: Any]) {
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let categoryValue = dictionary["category"] as? Int,
              let category = LogCategory(rawValue: categoryValue),
              let title = dictionary["title"] as? String,
              let createdAtString = dictionary["createdAt"] as? String,
              let updatedAtString = dictionary["updatedAt"] as? String
        else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        guard let createdAt = dateFormatter.date(from: createdAtString),
              let updatedAt = dateFormatter.date(from: updatedAtString)
        else { return nil }

        self.id = id
        self.recordId = nil
        self.category = category
        self.title = title
        
        if let latestMemoString = dictionary["latestMemo"] as? String {
            self.latestMemo = latestMemoString.split(separator: ",").map(String.init)
        } else {
            self.latestMemo = nil
        }

        self.isBookmarked = dictionary["isBookmarked"] as? Int ?? 0
        self.isLocked = dictionary["isLocked"] as? Int ?? 0
        self.isPinned = dictionary["isPinned"] as? Int ?? 0
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
