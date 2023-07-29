//
//  LogCell.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/20.
//

import SwiftUI

struct LogCell: View {
    
    var log: Log
    
    // AppleSDGothicNeoB
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            //MARK: 제목
            HStack(spacing: 0) {
                Text("")
                    .frame(width: 32, height: 0)
                Text(log.title)
                    .font(.custom("AppleSDGothicNeo-Bold", size: 18))
                    .frame(height: 29)
                    
                Image("pin")
                    .opacity(log.isPinned == 1 ? 1 : 0)
                    .padding(.leading, 10)
                    
                Spacer()
            }
            .padding(.top, 12)
            
            //MARK: 최근 메모
            VStack(alignment: .leading, spacing: 3) {
                if let latestMemo = log.latestMemo {
                    let range = 0..<min(latestMemo.count, 2)
                    ForEach(range, id: \.self) { index in
                        Text("•  \(latestMemo[index])")
                            .font(.custom("AppleSDGothicNeo-Regular", size: 13))
                    }
                }
            }
            .redacted(reason: log.isLocked == 0 ? [] : .placeholder)
            .padding(.leading, 32)
            .padding(.top, 4)
            
            //MARK: 메모 날짜
            Text("\(formatDateToString(date: log.createdAt)) ~ \(formatDateToString(date: log.updatedAt))")
                .foregroundColor(.gray)
                .font(.custom("AppleSDGothicNeo-Medium", size: 13))
                .frame(height: 21)
                .padding(.top, 2)
                .padding(.leading, 52)
                .redacted(reason: log.isLocked == 0 ? [] : .placeholder)
            
            Spacer()
        }
        .frame(height: 118)
        .frame(maxWidth: .infinity)

    }
    
    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y.M.d"
        return dateFormatter.string(from: date)
    }
}
