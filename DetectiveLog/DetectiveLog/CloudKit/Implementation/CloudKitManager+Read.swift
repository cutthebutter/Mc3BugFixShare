//
//  CloudKitManager+Read.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/25.
//

import Foundation
import CloudKit

extension CloudKitManager {
    /// func fetchLog: Cloudkit에 저장된 Log(Main) 데이터를 불러옵니다.
    /// - Parameter : (LogList) -> ()
    func fetchLogRecord(_ completion: @escaping (([Log]) -> ())) {
        var logList: [Log] = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Log", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        let operation = CKQueryOperation(query: query)
        operation.database = container
        
        operation.recordMatchedBlock = { recordId, result in
            switch result {
            case .success(let record):
                guard let category = record["category"] as? Int,
                      let title = record["title"] as? String,
                      let createdAt = record["createdAt"] as? Date,
                      let updatedAt = record["updatedAt"] as? Date,
                      let isBookmarked = record["isBookmarked"] as? Int,
                      let isLocked = record["isLocked"] as? Int,
                      let isPinned = record["isPinned"] as? Int,
                      let logCategory = LogCategory(rawValue: category)
                else {
                    print("@fetchLogRecord return")
                    return }
                logList.append(Log(id: UUID(),
                                   recordId: record.recordID,
                                   category: logCategory,
                                   title: title,
                                   latestMemo: record["latestMemo"] as? [String] ?? [],
                                   isBookmarked: isBookmarked,
                                   isLocked: isLocked,
                                   isPinned: isPinned,
                                   createdAt: createdAt,
                                   updatedAt: updatedAt))
                
            case .failure(let error):
                print("@Log recordMtachedBlock error - \(error.localizedDescription)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success(_):
                completion(logList)
            case .failure(let error):
                print("@Log queryResultBlokc error - \(error.localizedDescription)")
            }
        }
        
        operation.start()
    }
    
    /// func fetchDetailLogRecord
    /// - Parameter : CKRecord.ID
    func fetchDetailLogRecord(id: CKRecord.ID, _ completion: @escaping ((Log) -> ())) {
        container.fetch(withRecordID: id) { record, error in
            guard let record = record,
                  let category = record["category"] as? Int,
                  let title = record["title"] as? String,
                  let createdAt = record["createdAt"] as? Date,
                  let updatedAt = record["updatedAt"] as? Date,
                  let isBookmarked = record["isBookmarked"] as? Int,
                  let isLocked = record["isLocked"] as? Int,
                  let isPinned = record["isPinned"] as? Int,
                  let logCategory = LogCategory(rawValue: category)
            else { return }
            if let error = error {
                print("@Log fetchDetailLogRecord error - \(error.localizedDescription)")
            }
            let log = Log(id: UUID(),
                          recordId: record.recordID,
                          category: logCategory,
                          title: title,
                          latestMemo: record["latestMemo"] as? [String] ?? [],
                          isBookmarked: isBookmarked,
                          isLocked: isLocked,
                          isPinned: isPinned,
                          createdAt: createdAt,
                          updatedAt: updatedAt)
            completion(log)
        }
    }
    
    /// func fetchLogMemoRecord: CloudKit에 저장된 LogMemo(Detail) 데이터를 불러옵니다.
    /// - Parameter : log: Log
    func fetchLogMemoRecord(log: Log, _ completion: @escaping (([LogMemo]) -> ())) {
        var logMemoList: [LogMemo] = []
        guard let logRecordId = log.recordId else { return }
        let predicate = NSPredicate(format: "id == %@", logRecordId)
        let query = CKQuery(recordType: "LogMemo", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.database = container
        
        operation.recordMatchedBlock = { recordId, result in
            switch result {
            case .success(let record):
                guard let referenceId = record["id"] as? CKRecord.Reference,
                      let memo = record["memo"] as? String,
                      let logMemoDate = record["logMemoDate"] as? Date,
                      let createdAt = record["createdAt"] as? Date
                else {
                    return
                }
                logMemoList.append(LogMemo(id: logRecordId,
                                           referenceId: referenceId,
                                           memo: memo,
                                           logMemoDate: logMemoDate,
                                           createdAt: createdAt))
            case .failure(let error):
                print("@Log fetchLogMemoRecord - \(error.localizedDescription)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success(_):
                completion(logMemoList)
            case .failure(let error):
                print("@Log queryResultBlokc error - \(error.localizedDescription)")
            }
        }
        
        operation.start()
        
    }
    
    /// func fetchLogOpinionRecord: CloudKit Datebase에서 사견을 불러옵니다.
    /// - Parameter : log: Log
    func fetchLogOpinionRecord(log: Log, _ completion: @escaping (([LogOpinion]) -> ())) {
        var logOpinion: [LogOpinion] = []
        guard let logRecordId = log.recordId else { return }
        let predicate = NSPredicate(format: "id == %@", logRecordId)
        let query = CKQuery(recordType: "LogMemo", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.database = container
        
        operation.recordMatchedBlock = { recordId, result in
            switch result {
            case .success(let record):
                guard let referenceId = record["id"] as? CKRecord.Reference,
                      let opinion = record["opinion"] as? String,
                      let createdAt = record["createdAt"] as? Date
                else { return }
                logOpinion.append(LogOpinion(id: record.recordID,
                                             referenceId: referenceId,
                                             opinion: opinion,
                                             createdAt: createdAt))
            case .failure(let error):
                print("@Log fetchLogOpinionRecord error - \(error.localizedDescription)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success(_):
                completion(logOpinion)
            case .failure(let error):
                print("@Log fetchLogOpinionRecord error - \(error.localizedDescription)")
            }
        }
        operation.start()
    }
    
}
