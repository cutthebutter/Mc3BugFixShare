//
//  MemoRecordView.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/24.
//

import SwiftUI

struct LogRecordView: View {
    @State private var temporaryDictation : String = "None"
    @State private var showLogTitleSelectionView = false
    @State private var selectedTitle : String?
    
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
                LogTitleSelectionView(selectedTitle: $selectedTitle)
                    .onDisappear {
                        if let selectedtitle = selectedTitle{
                            //TODO: Log 데이터로 포맷팅 해줘야 함.
//                            let memo = Memo(category: category, content: temporaryDictation)
//                            saveMemo(memo)
                            print("@Log: \(temporaryDictation), \(selectedtitle)")
                        }
                    }
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
    
    func saveLog(){
        print("@log : saveLog()")
        //TODO: 여기서 코어데이터에 데이터를 보내는 걸 구현해줘야 함 
    }
}

struct MemoRecordView_Previews: PreviewProvider {
    static var previews: some View {
        LogRecordView()
    }
}
