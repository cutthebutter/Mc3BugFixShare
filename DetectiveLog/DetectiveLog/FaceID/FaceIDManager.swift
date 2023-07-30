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
    
    enum AuthCase {
        case updateAuth(log: Log, completion: (Int) -> ())
        case detailAuth(completion: (Bool) -> ())
    }
    
    func authenticate(authCase: AuthCase) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch authCase {
            case .updateAuth(let log, let completion):
                let reason = "메모를 잠그기 위해서는 생체인증이 필요합니다."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                    if success {
                        self.cloudKitManager.updateLogRecordIsLocked(log: log, isLocked: log.isLocked == 0 ? 1 : 0)
                        completion(log.isLocked == 0 ? 1 : 0)
                    }
                }
            case .detailAuth(let completion):
                let reason = "잠겨있는 메모를 확인하기 위해서는 생체인증이 필요합니다."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                    if success {
                        completion(success)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
}


