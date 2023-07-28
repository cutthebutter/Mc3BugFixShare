//
//  TempView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/24.
//

import SwiftUI

@available(iOS 16.0, *)
struct TempView: View {
    
    @ObservedObject var tempViewModel = TempViewModel()
    @State var text = ""
    @State var selectLog: Log? = nil
    @State var logCount: Int
    
    var body: some View {
        VStack {
//            TextField("Hi", text: $text, axis)
            TextField("wpojejfpwoef", text: $text, axis: .vertical)
                .lineLimit(1...)
//                .lineLimit(nil)
                .background(.mint)
                
                    //            tempViewModel.createLog(count: logCount)
                
        }
        
    }
}

//struct TempView_Previews: PreviewProvider {
//    static var previews: some View {
//        TempView()
//    }
//}
