//
//  CloudKitManager+Delete.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/25.
//

import Foundation
import CloudKit

extension CloudKitManager {
    /// func deleteLogRecord: CloudKit Database에서 Log Record를 삭제합니다.
    /// - Parameter: Log
    func deleteLogRecord(log: Log) {
        guard let recordId = log.id else { return }
        container.delete(withRecordID: recordId) { recordId, error in
            if let error = error {
                print("@Log deleteLogRecord Error - \(error.localizedDescription)")
            }
            print("@Log - \(log.title) 삭제 완료!")
        }
    }
}
