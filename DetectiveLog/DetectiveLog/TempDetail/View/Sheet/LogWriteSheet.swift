//
//  LogMemoWriteView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/29.
//

import SwiftUI

struct LogWriteSheet: View {
    
    @State var existLogMemo: String = ""
    @Environment(\.dismiss) var dismiss
    @Binding var memo: String
    @Binding var isPresented: Bool //  수정 화면을 같이 내려주기 위함
    @Binding var isFinishButtonClicked: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button {
                    memo = existLogMemo
                    isPresented.toggle()
                } label: {
                    Text("취소")
                }
                .padding(.leading, 20)
                Spacer()
                Button {
                    isPresented.toggle()
                    isFinishButtonClicked.toggle()
                } label: {
                    Text("완료")
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 14)
            .padding(.bottom, 20)
            
            HStack(alignment: .top, spacing: 0) {
                Text(dateToTime(date: Date()))
                    .font(.custom("AppleSDGothicNeo", size: 16))
                    .padding(.top, 8)
                    .padding(.leading, 20)
                    .foregroundColor(Color(red: 178 / 255,
                                           green: 178 / 255,
                                           blue: 178 / 255))
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(red: 205 / 255,
                                  green: 205 / 255,
                                  blue: 205 / 255),
                            lineWidth: 0.5)
                    .frame(height: 160)
                    .padding(.leading, 12)
                    .padding(.trailing, 20)
                    .overlay {
                        TextEditor(text: $memo)
                            .font(.custom("AppleSDGothicNeo", size: 14))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 2)
                    }
            }
            Spacer()
        }
        .onAppear {
            existLogMemo = memo
        }
    }
    
    func dateToTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
