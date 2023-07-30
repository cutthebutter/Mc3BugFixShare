//
//  CloudKitManager+Create.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/25.
//

import Foundation
import CloudKit

extension CloudKitManager {
    /// func createLogRecord: CloudKit Database에 디테일뷰로 가기 이전의 데이터를 저장합니다.
    /// - Parameter: Log
    func createLogRecord(log: Log, _ completion: @escaping ((CKRecord.ID) -> ())) {
        let record = CKRecord(recordType: "Log")
        record.setValue(log.title, forKey: "title")
        record.setValue(log.category.rawValue, forKey: "category")
        record.setValue(log.createdAt, forKey: "createdAt")
        record.setValue(log.updatedAt, forKey: "updatedAt")
        record.setValue(log.isBookmarked, forKey: "isBookmarked")
        record.setValue(log.isLocked, forKey: "isLocked")
        record.setValue(log.isPinned, forKey: "isPinned")
        record.setValue(log.latestMemo, forKey: "latestMemo")
        container.save(record) { record, error in
            if let error = error {
                print("@Log createLogRecord Error - \(error.localizedDescription)")
            }
            if let record = record {
                print("@Log createLogRecord 완료!")
                completion(record.recordID)
            }
        }
    }
    
    // 
    func createLogMemoRecord(log: Log, logMemo: LogMemo) async -> CKRecord.ID? {
        guard let logId = log.recordId else { return nil }
        let record = CKRecord(recordType: "LogMemo")
        record.setValue(CKRecord.Reference(recordID: logId, action: .none), forKey: "id") // 데이터 연관을 위함.
        record.setValue(logMemo.memo, forKey: "memo")
        record.setValue(logMemo.logMemoDate, forKey: "logMemoDate")
        record.setValue(logMemo.createdAt, forKey: "createdAt")
        do {
            let saveRecord = try await container.save(record)
            return saveRecord.recordID
        } catch {
            print("@Log createLogMemoRecord - \(error.localizedDescription)")
            return nil
        }
    }
    
    /// func createLogOpinionRecord: CloudKit Database에 새로운 사견을 추가합니다.
    ///
    func createdLogOpinionRecord(log: Log, logOpinion: LogOpinion) {
        guard let logId = log.recordId else { return }
        let record = CKRecord(recordType: "LogOpinion")
        record.setValue(CKRecord.Reference(recordID: logId, action: .none), forKey: "id")
        record.setValue(logOpinion.opinion, forKey: "opinion")
        record.setValue(logOpinion.createdAt, forKey: "createdAt")
        container.save(record) { record, error in
            if let error = error {
                print("@Log createdLogOpinionRecord error - \(error.localizedDescription)")
            }
            print("@Log createdLogOpinionRecord 완료!")
        }
    }
}
