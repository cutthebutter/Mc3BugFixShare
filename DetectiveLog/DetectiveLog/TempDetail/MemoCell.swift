//
//  MemoCell.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/26.
//

import SwiftUI
import Combine

@available(iOS 16.0, *)
extension DetailLogView {
    
    func memoCell(logMemo: Binding<LogMemo>) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(dateToTime(date: logMemo.createdAt.wrappedValue))
                .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                .opacity(0.3)
                .padding(.bottom, 22)
                .padding(.leading, 28)
            
            // 키보드 반응형 깔끔하게 하는 방법
            // 키보드 올라갈때 스크롤의 최 하단에 위치하게 하는 방법
            // 키보드 내려갈 때
            Text(logMemo.memo.wrappedValue)
                .font(.custom("AppleSDGothicNeo-Regular", size: 14))
                .padding(.leading, 20)
                .padding(.trailing, 50)
                .padding(.bottom, 22)
            
//            TextEditor(text: logMemo.memo)
//                .padding(.top, 0)
                
        
            Spacer()
        }

    }
    
    func dateToTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: date)
    }
    
}

//
//@available(iOS 16.0, *)
//struct MemoCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoCell(logMemo: LogMemo(id: UUID(), recordId: nil, referenceId: nil, memo: "질곡동 사건", logMemoDate: Date(), createdAt: Date()))
//    }
//}
