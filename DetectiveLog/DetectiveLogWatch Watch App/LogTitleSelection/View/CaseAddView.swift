//
//  CaseAddView.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/24.
//

import SwiftUI

struct CaseAddView: View {
    @Binding var text: String
    @Binding var isPresenting: Bool
    
    var body: some View {
        Button("입력 받기") {
            presentTextInput()
        }
    }
    
    
    func presentTextInput() {
        let controller = WKExtension.shared().visibleInterfaceController
        controller?.presentTextInputController(withSuggestions: nil, allowedInputMode: .plain) { results in
            if let result = results?.first as? String {
                text = result
                isPresenting = false
            }
        }
    }
}

//struct CaseAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        CaseAddView()
//    }
//}
