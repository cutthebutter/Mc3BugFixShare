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
    static let shared = CloudKitManager()
    
    // 유저 개인 privateDatabase
    private var container = CKContainer(identifier: "iCloud.com.kozi.detectiveLog").privateCloudDatabase
    
    //MARK: Methods
    
    /// func fetchMemo: Cloudkit에 저장된 LogList(Main) 데이터를 불러옵니다.
    /// - Parameter: (LogList) -> ()
    func fetchLogList(_ completion: @escaping (([LogList]) -> ())) {
        var logList: [LogList] = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "LogList", predicate: predicate)
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
                      let isLocked = record["isLocked"] as? Int,
                      let isPinned = record["isPinned"] as? Int,
                      let logCategory = LogCategory(rawValue: category)
                else { return }
                
                logList.append(LogList(id: record.recordID,
                                       category: logCategory,
                                       title: title,
                                       latestMemo: latestMemo,
                                       isLocked: isLocked == 1,
                                       isPinned: isPinned == 1,
                                       createdAt: createdAt,
                                       updatedAt: updatedAt))
                
            case .failure(let error):
                print("@Log error - \(error.localizedDescription)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success(_):
                completion(logList)
            case .failure(let error):
                print("@Log error - \(error.localizedDescription)")
            }
        }
        
        operation.start()
    }
    
    /// func 디테일데이터패치
    
}
