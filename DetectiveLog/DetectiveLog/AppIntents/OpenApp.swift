//
//  OpenApp.swift
//  DetectiveLog
//
//  Created by semini on 2023/07/25.
//

import Foundation
import AppIntents
import SwiftUI

//TODO: 현재 ViewModel이 outofScope
//TODO: iOS 15에서도 구동하는 방법을 찾을 것,,
//@available(iOS 16, *)

//struct OpenApp : AppIntent {
//    init() {
//    }
//
//    //밖에 보이는 타이틀
//    static var title : LocalizedStringResource = "앱 바로가기"
//
//    static var description: IntentDescription = IntentDescription("앱을 바로 실행할 수 있는 기능입니다. ")
//
//    static var openAppWhenRun = true
//    //내부에 보이는 작동 타이틀
//    static var parameterSummary: some ParameterSummary {
//        Summary("앱 열기")
//    }
//
//    @MainActor
//    func perform() async throws -> some IntentResult {
//        LogViewModel.shared.navigateToMain()
//        return .result()
//    }
//}
