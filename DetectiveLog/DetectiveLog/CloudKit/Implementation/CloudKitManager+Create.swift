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
    func createLogRecord(log: Log) {
        let record = CKRecord(recordType: "Log")
        record.setValue(log.title, forKey: "title")
        record.setValue(log.category.rawValue, forKey: "category")
        record.setValue(log.createdAt, forKey: "createdAt")
        record.setValue(log.updatedAt, forKey: "updatedAt")
        record.setValue(log.isBookmarked, forKey: "isBookmarked")
        record.setValue(log.isLocked, forKey: "isLocked")
        record.setValue(log.isPinned, forKey: "isPinned")
        record.setValue(log.latestMemo, forKey: "latestMemo")
        record.setValue(log.logMemoId, forKey: "logMemoId")
        record.setValue(log.logMemoDates, forKey: "logMemoDates")
        container.save(record) { record, error in
            if let error = error {
                print("@Log createLogRecord Error - \(error.localizedDescription)")
            }
            print("@Log - \(log.title) Save 완료!")
        }
    }
    
    func createLogMemoRecord(log: Log, logMemo: LogMemo) {
        guard let logId = log.recordId else { return }
        let record = CKRecord(recordType: "LogMemo")
        record.setValue(CKRecord.Reference(recordID: logId, action: .none), forKey: "id") // 데이터 연관을 위함.
        record.setValue(logMemo.memo, forKey: "memo")
        record.setValue(logMemo.logMemoDate, forKey: "logMemoDate")
        record.setValue(logMemo.createdAt, forKey: "createdAt")
        container.save(record) { record, error in
            if let error = error {
                print("@Log createLogMemoRecord Error - \(error.localizedDescription)")
            }
            print("@Log createLogMemoRecord 완료!")
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
