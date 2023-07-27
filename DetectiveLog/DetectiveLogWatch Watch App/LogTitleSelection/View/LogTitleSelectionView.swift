//
//  LogTitleSelectionView.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/24.
//

import SwiftUI

struct LogTitleSelectionView: View {
    @Binding var selectedTitle: String?
    
    @ObservedObject var viewModel = LogTitleSelectionViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var text = ""
    @State private var isPresenting = false
    
    //TODO: Cloudkit 데이터를 넣어야 함
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.fakeLog){ item in
                    Button{
                        selectedTitle = item.title
                        dismiss()
                    } label: {
                        Text(item.title)
                    }
                    
                }
                
                //TODO: 사건추가하기 뷰 적층구조 해결해야 함
                
                Button{
                    selectedTitle = presentTextInput()
                    
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


