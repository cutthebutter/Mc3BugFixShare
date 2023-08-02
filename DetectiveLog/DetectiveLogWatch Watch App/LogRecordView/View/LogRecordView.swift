//
//  MemoRecordView.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/24.
//

import SwiftUI
import WatchConnectivity
import WatchKit

struct LogRecordView: View {
    @ObservedObject var viewModel = LogRecordViewModel()
    @State var temporaryDictation : String = "None"
    @State var showLogTitleSelectionView = false
    @State var reachable = "No"
    
    @Environment(\.scenePhase) private var scenePhase
    
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack {
                    Button {
                        presentDictation()
                    } label: {
                        Image(systemName: "mic.fill")
                            .font(.title)
                            .padding(15)
                            .background(Color.gray)
                            .mask(Circle())
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("기록시작")
                    //MARK: reachable을 확인하기 위해 만들
                    Text("Reachable \(reachable)")
                    Button(action: {
                        if WatchSessionManagerWatch.shared.isWatchReachable{
                            self.reachable = "Yes"
                        }
                        else{
                            self.reachable = "No"
                        }
                    }) {
                        Text("Update")
                    }
                }
                .onChange(of: scenePhase) { (phase) in
                    switch phase {
                    case .active : presentDictation()
                    default : break
                    }
                }
            }
            .navigationTitle("CLUE")
            .navigationBarTitleDisplayMode(.inline)
            
            
            .sheet(isPresented: $showLogTitleSelectionView) {
//                TestView()
                LogTitleSelectionView(viewModel: WatchSessionManagerWatch.shared.logTitleSelectionViewModel, temporaryDictation : $temporaryDictation)
//                    .onDisappear {
//                        if let selectedLog = selectedLog{
//                            TODO: CKRecord.ID들 해결해야 함
//                            let newLogmMemo = LogMemo(id:nil, referenceId: CKRecord.Reference?, memo: temporaryDictation, logMemoDate: Date(), createdAt: Date())
//                            saveLogMemo(selectedLog: selectedLog, newLogMemo: newLogmMemo)
//                        }
//                    }
            }
            
        }
    }
    
    func presentDictation() {
        let hapticType = WKHapticType.start
        WKInterfaceDevice.current().play(hapticType)
        let root = WKExtension.shared().rootInterfaceController
        root?.presentTextInputController(withSuggestions: nil, allowedInputMode: .plain) { result in
            if let result = result as? [String], !result.isEmpty {
                let result0 = result[0].replacingOccurrences(of: " ", with: "")
                if result0 != "" {
                    temporaryDictation = result0
                    showLogTitleSelectionView = true
                }
            }else {return}
            root?.dismissTextInputController()
        }
    }
    
//    func saveLogMemo(selectedLog : Log, newLogMemo : LogMemo){
//        print("@log : saveLog()")
//        var selectedLogList = viewModel.fetchLogMemo(selectedLog: selectedLog)
//        if selectedLogList.count == 0 {
//            CloudKitManager.shared.createLogMemoRecord(log: selectedLog, logMemo: newLogMemo)
//            let defaultOpinion = "사견을 작성해주세요"
//        //TODO: CKRecord.ID들 해결해야 함
//            let emptyLogOpinion = LogOpinion(id: , referenceId: CKRecord.Reference, opinion: defaultOpinion, createdAt: Date())
//            CloudKitManager.shared.createdLogOpinionRecord(log: selectedLog, logOpinion: emptyLogOpinion)
//            //TODO: 저기 latestMemo에는 뭘 적지?
//            CloudKitManager.shared.updateLogRecord(log: selectedLog, latestMemo: [String], updatedAt: Date())
//        } else{
//            CloudKitManager.shared.createLogMemoRecord(log: selectedLog, logMemo: newLogMemo)
//            let defaultOpinion = "사견을 작성해주세요"
//            //TODO: 저기 latestMemo에는 뭘 적지?
//            CloudKitManager.shared.updateLogRecord(log: selectedLog, latestMemo: [String], updatedAt: Date())
//
//        }
//    }
}

struct MemoRecordView_Previews: PreviewProvider {
    static var previews: some View {
        LogRecordView()
    }
}
