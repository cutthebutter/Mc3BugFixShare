//
//  CloudKitManagerInterface.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/25.
//

import Foundation
import CloudKit

protocol CloudKitManagerInterface {
    
    //MARK: Create
    func createLogRecord(log: Log, _ completion: @escaping ((CKRecord.ID) -> ()))
    func createLogMemoRecord(log: Log, logMemo: LogMemo)
    func createdLogOpinionRecord(log: Log, logOpinion: LogOpinion)

    //MARK: Read
    func fetchLogRecord(_ completion: @escaping (([Log]) -> ()))
    func fetchLogMemoRecord(log: Log) async -> [LogMemo]
    func fetchLogOpinionRecord(log: Log) async -> [LogOpinion]

    //MARK: Update
    func updateLogRecord(log: Log, latestMemo: [String], updatedAt: Date)
    func updateLogRecordCategory(log: Log, category: LogCategory)
    func updateLogRecordIsPinned(log: Log, isPinned: Int)
    func updateLogMemoRecord(logMemo: LogMemo)
    func updateLogOpinionRecord(logOpinion: LogOpinion)

    //MARK: Delete
    func deleteLogRecord(log: Log)
    
}


