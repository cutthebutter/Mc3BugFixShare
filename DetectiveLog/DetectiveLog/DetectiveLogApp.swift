//
//  DetectiveLogApp.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import SwiftUI

@main
struct DetectiveLogApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        WatchSessionManagerIOS.shared.startSession()
    }

    var body: some Scene {
        WindowGroup {
//            CategoryView()
            LogView()
//            SearchTestView()
//            CalendarView()
        }
    }
}
