//
//  DetailLogMenuSheet.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/29.
//

import SwiftUI

@available(iOS 16.0, *)
struct DetailLogMenuSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @State var isEditPresented: Bool = false
    @Binding var logMemo: LogMemo
    @Binding var isPresented: Bool
    @Binding var isEditButtonClicked: Bool
    
    var body: some View {
        List {
            HStack(spacing: 0 ) {
                Button {
                    isEditPresented.toggle()
                } label: {
                    Text("수정하기")
                }
            }
            HStack(spacing: 0 ) {
                Button {
                    
                } label: {
                    Text("삭제하기")
                }
            }
        }
        .sheet(isPresented: $isEditPresented, content: {
            LogWriteSheet(memo: $logMemo.memo,
                          isPresented: Binding.constant(isPresented),
                          isFinishButtonClicked: $isEditButtonClicked)
            .presentationDetents([.height(247)])
        })
    }
    
}


