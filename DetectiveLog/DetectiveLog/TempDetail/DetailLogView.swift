//
//  DetailLogView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/26.
//

import SwiftUI

struct DetailLogView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if let log = viewModel.log {
                Text(log.title)
                combineLogCell
                    .listRowInsets(EdgeInsets())
            }
        }
        .onAppear {
            if let log = viewModel.log {
                viewModel.fetchLogMemo(log: log)
            } else {
                viewModel.createLog()
            }
        }
    }
    
    var combineLogCell: some View {
        List {
            ForEach(viewModel.combineLogData) { logData in
                DateCell(combineLogData: logData)
//                let range = 0..<logData.logMemo.count
                ForEach(logData.logMemo, id: \.self) { logMemo in
                    MemoCell(logMemo: logMemo)
                }
//                ForEach(range, content: <#T##(Int) -> TableRowContent#>)
//                ForEach(range) { Int in
//                    <#code#>
//                }
            }
        }
    }
    
//    func memoCell(logMemo: LogMemo) -> some View {
//        return         HStack(alignment: .top, spacing: 0) {
//            Text(formatDateToString(date: logMemo.createdAt))
//                .font(.custom("AppleSDGothicNeo-Regular", size: 16))
//                .opacity(0.3)
//                .padding(.leading, 28)
//
//            Text(logMemo.memo)
//                .font(.custom("AppleSDGothicNeo-Regular", size: 14))
//                .frame(alignment: .topLeading)
//                .padding(.leading, 20)
//                .padding(.trailing, 50)
//
//            Spacer()
//        }
//    }
    
    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: date)
    }
    
}

//struct DetailLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailLogView()
//    }
//}
