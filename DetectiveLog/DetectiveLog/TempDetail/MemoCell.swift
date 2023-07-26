//
//  MemoCell.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/26.
//

import SwiftUI

struct MemoCell: View {
    
    var logMemo: LogMemo

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(formatDateToString(date: logMemo.createdAt))
                .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                .opacity(0.3)
                .padding(.leading, 28)
            
            Text(logMemo.memo)
                .font(.custom("AppleSDGothicNeo-Regular", size: 14))
                .frame(alignment: .topLeading)
                .padding(.leading, 20)
                .padding(.trailing, 50)
            
            Spacer()
        }
        .background(.orange)
    }
    
    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: date)
    }
    
}

//struct MemoCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoCell(logMemo: LogMemo(id: nil, referenceId: nil, memo: "눈꽃을 나누다 삼겹살집에 가면, 항상 소주 한병 이상을 먹게 되더라구요.", logMemoDate: Date(), createdAt: Date()))
//    }
//}
