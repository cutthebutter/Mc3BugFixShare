//
//  CloudKitManager.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import Foundation

import CloudKit

protocol CloudKitManagerInterface {
    // Create Methods
    // Read Methods
    // Update Methods
    // Delete Methods
}

final class CloudKitManager {
    
    //MARK: Properties
    // 싱글톤
    static let shared = CloudKitManager()
    
    // 유저 개인 privateDatabase
    private var container = CKContainer(identifier: "iCloud.com.kozi.detectiveLog").privateCloudDatabase
    
    //MARK: Read
    
    /// func fetchLog: Cloudkit에 저장된 Log(Main) 데이터를 불러옵니다.
    /// - Parameter: (LogList) -> ()
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
                      let latestMemo = record["latestMemo"] as? [String],
                      let createdAt = record["createdAt"] as? Date,
                      let updatedAt = record["updatedAt"] as? Date,
                      let isBookmarked = record["isBookmarked"] as? Int,
                      let isLocked = record["isLocked"] as? Int,
                      let isPinned = record["isPinned"] as? Int,
                      let logMemoDates = record["logMemoDates"] as? [Date],
//                      let logMemoId = record["logMemoId"] as? [CKRecord.Reference] ?? [],
                      let logCategory = LogCategory(rawValue: category)
                else {
                    print("@Log return")
                    return }
                logList.append(Log(id: record.recordID,
                                   category: logCategory,
                                   title: title,
                                   latestMemo: latestMemo,
                                   isBookmarked: isBookmarked,
                                   isLocked: isLocked,
                                   isPinned: isPinned,
                                   createdAt: createdAt,
                                   updatedAt: updatedAt,
                                   logMemoDates: logMemoDates,
                                   logMemoId: record["logMemoId"] as? [CKRecord.Reference] ?? [])) // 아직 디테일 작성 안되었을경우?
                print("@Log - \(logList)")
                
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
    
    /// func fetchLogMemoRecord: CloudKit에 저장된 LogMemo(Detail) 데이터를 불러옵니다.
    func fetchLogMemoRecord(log: Log, _ completion: @escaping (([LogMemo]) -> ())) {
        var logMemoList: [LogMemo] = []
        let logRecordId = log.id
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
    
    //MARK: Create
    
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
        let record = CKRecord(recordType: "LogMemo")
        record.setValue(CKRecord.Reference(recordID: log.id, action: .none), forKey: "id") // 데이터 연관을 위함. 
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
    
    /// func createLogMemoRecord
    
    //MARK: Update
    
    /// func updateLogRecordCategory: 메인 뷰에서 Log의 카테고리를 이동할 때 사용합니다.
    /// - Parameter: [Log], LogCategory
    func updateLogRecordCategory(log: Log, category: LogCategory) {
        let recordId = log.id
        container.fetch(withRecordID: recordId) { record, error in
            guard let record = record else {
                if let error = error {
                    print("@Log changeLogRecordCategoryError - \(error.localizedDescription)")
                }
                return
            }
            record["category"] = category.rawValue
            self.container.save(record) { record, error in
                if let error = error {
                    print("@Log changeLogRecordCategoryErrorSave - \(error.localizedDescription)")
                } else {
                    print("@Log changeLogRecordCategory 완료!")
                }
            }
        }
    }
    
    func changeLogRecordIsPinned(log: Log, isPinned: Int) {
        let recordId = log.id
        container.fetch(withRecordID: recordId) { record, error in
            guard let record = record else {
                if let error = error {
                    print("@Log changeLogRecordIsPinned - \(error.localizedDescription)")
                }
                return
            }
            record["isPinned"] = isPinned
            self.container.save(record) { record, error in
                if let error = error {
                    print("@Log changeLogRecordIsPinnedSave - \(error.localizedDescription)")
                } else {
                    print("@Log changeLogRecordIsPinned 완료!")
                }
            }
        }
    }
    
    func updateLogMemoRecord(logMemo: LogMemo) {
        let recordId = logMemo.id
        container.fetch(withRecordID: recordId) { record, error in
            guard let record = record else {
                if let error = error {
                    print("@Log updateLogMemoRecord - \(error.localizedDescription)")
                }
                return
            }
            record["logMemo"] = logMemo.memo
//            record["createdAt"] = logMemo.createdAt
            self.container.save(record) { record, error in
                if let error = error {
                    print("@Log updateLogMemoRecord - \(error.localizedDescription)")
                } else {
                    print("@Log updateLogMemoRecord 완료!")
                }
            }
        }
    }
    
    
    //MARK: Delete

    /// func deleteLogRecord: CloudKit Database에서 Log Record를 삭제합니다.
    /// - Parameter: Log
    func deleteLogRecord(log: Log) {
        let recordId = log.id
        container.delete(withRecordID: recordId) { recordId, error in
            if let error = error {
                print("@Log deleteLogRecord Error - \(error.localizedDescription)")
            }
            print("@Log - \(log.title) 삭제 완료!")
        }
    }
    
}
