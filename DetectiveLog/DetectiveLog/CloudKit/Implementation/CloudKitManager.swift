//
//  CloudKitManager.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import Foundation

import CloudKit

//protocol CloudKitManagerInterface {
    // Create Methods
    // Read Methods
    // Update Methods
    // Delete Methods
//}

final class CloudKitManager: CloudKitManagerInterface {
    
    static let shared = CloudKitManager()
    
    //MARK: Properties
    var container = CKContainer(identifier: "iCloud.com.kozi.detectiveLog").privateCloudDatabase

}
