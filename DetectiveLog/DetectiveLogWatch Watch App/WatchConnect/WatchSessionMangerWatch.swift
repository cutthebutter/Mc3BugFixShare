//
//  WatchSessionMangerWatch.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/08/01.
//

import Foundation
import WatchConnectivity

class WatchSessionManagerWatch:  NSObject, WCSessionDelegate,ObservableObject {
    
    static let shared = WatchSessionManagerWatch()
    var logTitleSelectionViewModel = LogTitleSelectionViewModel()
    
    
    @Published var isWatchReachable: Bool = false
    
    private override init() {
        super.init()
    }
    
    func startSession() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        isWatchReachable = session.isReachable
    }
    
    func requestLogFromiOS() {
        if WCSession.default.isReachable {
            print("@Log_watch: requestLog Watch to iOS ")
            WCSession.default.sendMessage(["request": "requestLog"], replyHandler: nil, errorHandler: { error in
                print("Error sending message to iOS: \(error.localizedDescription)")
            })
        }
    }
    
    func sendNewLogMemoFromWatch(message: [String:Any]) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Error sending message to iOS: \(error.localizedDescription)")
            })
            print("@Log_wat ch 데이터 감\(message)")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let response = applicationContext["response"] as? String {
            print("Received data from iOS-applicationContext: \(response)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let response = message["response"] as? String {
            print("Received data from iOS: \(response)")
            // 워치에서 데이터 처리
        }
        ///LogList를 받아오는 처리 
        if let logListDictionary = message["logList"] as? [[String: Any]] {
            var logList: [Log] = []
            for logDict in logListDictionary {
                if let log = Log(from: logDict) {
                    logList.append(log)
                }
            }
            logTitleSelectionViewModel.updateLogList(logList: logList) // 로그 리스트 업데이트
        }
    }

    
}
