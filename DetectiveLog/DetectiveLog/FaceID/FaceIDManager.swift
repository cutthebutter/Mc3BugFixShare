//
//  FaceIDManager.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/28.
//

import Foundation
import LocalAuthentication
import SwiftUI

class FaceIDManager {
    
    let cloudKitManager = CloudKitManager.shared

    func authenticate(log: Log) {
        print("@Log authenticate - \(log)")
        let context = LAContext()
        var error: NSError?
        // password 제외 생체인증(FaceID, 지문인증)
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "메모를 잠그기 위해서는 생체인증이 필요합니다."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    if log.isLocked == 0 {
                        self.cloudKitManager.updateLogRecordIsLocked(log: log, isLocked: 1)
                    } else {
                        self.cloudKitManager.updateLogRecordIsLocked(log: log, isLocked: 0)
                    }
                }
            }
        } else {
            print("생체인증을 하지 않아요")
        }
    }
}
