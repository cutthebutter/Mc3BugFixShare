//
//  LogTitleSelectionView.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/24.
//

import SwiftUI

struct LogTitleSelectionView: View {
    @Binding var selectedLog: Log?
    
    @ObservedObject var viewModel = LogTitleSelectionViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var text = ""
    @State private var isPresenting = false
    
    //TODO: Cloudkit 데이터를 넣어야 함
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.log) { item in
                    Button{
                        selectedLog = item
                        dismiss()
                    } label: {
                        Text(item.title)
                    }
                    
                }
                Button{
                    $viewModel.cloudKitManager.createLogRecord(log: Log(id: nil, recordId: nil, category:.inProgress, title: "\(viewModel.log.count + 1) 번째 사건일지", latestMemo: nil, isBookmarked: 0, isLocked: 0, isPinned: 0, createdAt: Date(), updatedAt: Date(), logMemoDates: nil, logMemoId: nil))
                    
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


