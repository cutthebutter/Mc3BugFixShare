//
//  LogTitleSelectionView.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/24.
//

import SwiftUI
import WatchConnectivity

struct LogTitleSelectionView: View {
    //    @Binding var selectedLog: Log?
    @ObservedObject var viewModel : LogTitleSelectionViewModel
    @Binding var temporaryDictation : String
    
    @Environment(\.dismiss) var dismiss
    
    @State private var text = ""
    @State private var isPresenting = false
    
    //TODO: Cloudkit 데이터를 넣어야 함
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.logList) { log in
                    Button{
                        let logDictionary = log.toDictionary()
                        let newLogMemo: [String: Any] = [
                            "selectLog": logDictionary,
                            "temporaryDictation": temporaryDictation
                        ]
                        print("@Log_watch Sending message: \(newLogMemo)")
                        
                        // iOS로 메시지 보내기
                        if WCSession.default.isReachable {
                            WCSession.default.sendMessage(newLogMemo, replyHandler: {_ in
                                print("@Log_watch 데이터 감-repyHandelr\(newLogMemo)")
                            }, errorHandler: { error in
                                print("@Log_watch Error sending message to iOS: \(error)")
                                print("@Log_watch Error details: \(error.localizedDescription)")
                            })
                            print("@Log_watch 데이터 감\(newLogMemo)")
                            dismiss()
                        }
                        
                //        ["request": "requestLog"]
//                        if message["request"] as? String == "requestLog" {
//                            print("@Log_iOS: if message [request] as? String == requestLog")
//                            sendLogListToWatch()
//                        }

//                        dismiss()
                    } label: {
                        Text(log.title)
                    }
                    
                }
                Button{
                    //                    $viewModel.cloudKitManager.createLogRecord(log: Log(id: nil, recordId: nil, category:.inProgress, title: "\(viewModel.log.count + 1) 번째 사건일지", latestMemo: nil, isBookmarked: 0, isLocked: 0, isPinned: 0, createdAt: Date(), updatedAt: Date(), logMemoDates: nil, logMemoId: nil))
                    
                } label: {
                    HStack{
                        Image(systemName: "plus")
                        Text("사건 추가하기")
                    }
                    .foregroundColor(.accentColor)
                }
            }
            .navigationTitle("사건 선택")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear{
            WatchSessionManagerWatch.shared.requestLogFromiOS()
        }
    }
    
    func presentTextInput() -> String {
        var temprorySpeach = ""
        let controller = WKExtension.shared().visibleInterfaceController
        controller?.presentTextInputController(withSuggestions: nil, allowedInputMode: .plain) { results in
            if let result = results?.first as? String {
                temprorySpeach = result
            }else {return}
        }
        return temprorySpeach
    }
}


//struct LogTitleSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogTitleSelectionView()
//    }
//}


