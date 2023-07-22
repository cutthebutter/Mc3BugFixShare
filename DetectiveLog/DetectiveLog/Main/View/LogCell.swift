//
//  LogCell.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/20.
//

import SwiftUI

struct LogCell: View {
    
//    var log: Log

    var tempLog: TempLog
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("")
                    .frame(width: 0, height: 0)
                Image(systemName: "pin")
                    .opacity(tempLog.isPinned ? 1 : 0)
                    .padding(.leading)
                Text(tempLog.title)
                    .font(Font.system(size: 18, weight: .bold))
                Text("\(tempLog.createdAt) ~ \(tempLog.updatedAt)")
                    .foregroundColor(.gray)
                    .font(Font.system(size: 13))
                Spacer()
            }
            .padding(.bottom, 2)
            VStack(alignment: .leading, spacing: 3) {
                ForEach(tempLog.latestMemo.indices, id: \.self) { index in
                    Text("•  \(tempLog.latestMemo[index])")
                        .font(Font.system(size: 13))
                        .padding(.leading, 45)
                }
            }
        }
        .frame(height: 117)
        .frame(maxWidth: .infinity)
    }
}

struct TempLog: Identifiable, Equatable {
    let id: UUID
    let title: String
    let createdAt: String
    let updatedAt: String
    let latestMemo: [String]
    let isPinned: Bool
    var category: LogCategory
}

struct LogCell_Previews: PreviewProvider {
    static var previews: some View {
        LogCell(tempLog: TempLog(id: UUID(), title: "질곡동 사건", createdAt: "7.17", updatedAt: "7.29", latestMemo: ["자라 한마리에 가격이 수백만원. 주변의 가게도 모두", "남자한테 좋다."], isPinned: true, category: LogCategory(rawValue: 0)!))
    }
}
