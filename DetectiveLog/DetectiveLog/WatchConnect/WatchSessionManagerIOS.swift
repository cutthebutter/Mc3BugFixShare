//
//  WatchSessionManagerIOS.swift
//  DetectiveLog
//
//  Created by semini on 2023/08/01.
//

import Foundation
import WatchConnectivity

class WatchSessionManagerIOS:  NSObject, WCSessionDelegate {
    
    static let shared = WatchSessionManagerIOS()
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
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        isWatchReachable = session.isReachable
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        print("@Log_iOS: Received message from watch: \(message)")
        
        if message["request"] as? String == "requestLog" {
            print("@Log_iOS: if message [request] as? String == requestLog")
            sendLogListToWatch()
        } else if let logDictionary = message["selectLog"] as? [String: Any],
           let temporaryDictation = message["temporaryDictation"] as? String {
            // logDictionary를 Log 객체로 변환
            print("@Log: logDictionary 받아짐")
            guard let log = Log(from: logDictionary) else {
                print("@Log_iOS:Failed to convert logDictionary to Log object")
                return }
            
            // temporaryDictation을 LogMemo 객체로 변환
            let logMemo = LogMemo(id: UUID(), recordId: nil, referenceId: nil, memo: temporaryDictation, logMemoDate: Date(), createdAt: Date())
            
            // 로그와 메모 저장
            saveLogAndMemo(log: log, logMemo: logMemo)
        } else {
            print("@Log logDictionary 오류!")
        }
    }
    
    func sendLogListToWatch() {
        print("@Log:sendLogListToWatch")
        CloudKitManager.shared.fetchLogRecord { logList in
            let logListDictionary = logList.map { $0.toDictionary() }
            let message = ["logList": logListDictionary]
            
            if WCSession.default.isReachable {
                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    print("Error sending log list to watch: \(error.localizedDescription)")
                })
            }
        }
        
    }
    
    func saveLogAndMemo(log: Log, logMemo: LogMemo) {
        Task {
            if let recordID = await CloudKitManager.shared.createLogMemoRecord(log: log, logMemo: logMemo) {
                print("Log and LogMemo successfully saved with recordID: \(recordID)")
            } else {
                print("Failed to save Log and LogMemo")
            }
        }
        
        // 로그 업데이트
        let latestMemo = [logMemo.memo] // 최신 메모 배열 업데이트
        let updatedAt = Date()
        CloudKitManager.shared.updateLogRecord(log: log, latestMemo: latestMemo, updatedAt: updatedAt)
        print("Log updated successfully")
    }
}



