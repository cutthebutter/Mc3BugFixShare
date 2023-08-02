//
//  TestView.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/08/01.
//

import SwiftUI
import WatchConnectivity

struct TestView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                if WCSession.default.isReachable {
                    WCSession.default.sendMessage(["request": "requestLog"], replyHandler: nil, errorHandler: nil)
                }
            }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()

        
    }
}
