//
//  CloudKitManager.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import Foundation

import CloudKit

final class CloudKitManager {
    
    //MARK: Properties
    // 싱글톤
    static let shared = CloudKitManager()
    
    // 유저 개인 privateDatabase
    private var container = CKContainer(identifier: "iCloud.com.kozi.detectiveLog").privateCloudDatabase
    
    //MARK: Methods
    
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
    /// func 디테일데이터패치
    
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
    
    /// func changeLogRecordCategory: 메인 뷰에서 Log의 카테고리를 이동할 때 사용합니다.
    /// - Parameter: Log, LogCategory
    func changeLogRecordCategory(log: Log, category: LogCategory) {
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
                    print("@Log - \(error.localizedDescription)")
                } else {
                    print("@Log changeLogRecordCategory 완료!")
                }
            }
        }
    }
    
    /// func createLogMemoRecord

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
