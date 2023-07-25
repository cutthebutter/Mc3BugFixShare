//
//  OpenAppIntent.swift
//  OpenAppIntent
//
//  Created by semini on 2023/07/25.
//

import AppIntents


struct OpenAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Clue"
    
    func perform() async throws -> some IntentResult {
        await 
        return .result()
    }
}
