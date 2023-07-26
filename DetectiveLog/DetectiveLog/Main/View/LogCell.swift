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
                // AppleSDGothicNeoB
                Text("")
                    .frame(width: 32, height: 0)
                Text(log.title)
                    .font(.custom("AppleSDGothicNeo-Bold", size: 18))
                    .frame(height: 29)
//                    .background(.black)
                    
                Image("pin")
                    .opacity(log.isPinned == 1 ? 1 : 0)
                    .padding(.leading, 10)
                    
                Spacer()
            }
//            .padding(.leading, 32)
            .padding(.top, 12)
            
            //MARK: 최근 메모
            VStack(alignment: .leading, spacing: 3) {
                if let latestMemo = log.latestMemo {
                    ForEach(latestMemo.indices, id: \.self) { index in
                        Text("•  \(latestMemo[index])")
                            .font(.custom("AppleSDGothicNeo-Regular", size: 13))
                            
                    }
                }
            }
            .padding(.leading, 32)
            .padding(.top, 4)
            
            //MARK: 메모 날짜
            Text("\(formatDateToString(date: log.createdAt)) ~ \(formatDateToString(date: log.updatedAt))")
                .foregroundColor(.gray)
                .font(.custom("AppleSDGothicNeo-Medium", size: 13))
                .frame(height: 21)
                .padding(.top, 2)
                .padding(.leading, 52)
            
            Spacer()
        }
        .frame(height: 118)
        .frame(maxWidth: .infinity)
//        .background(.indigo.opacity(0.1))
        
    }
    
    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y.M.d"
        return dateFormatter.string(from: date)
    }
}

struct LogCell_Previews: PreviewProvider {
    static var previews: some View {
        LogCell(log: Log(id: UUID(),
                         recordId: nil,
                         category: .inProgress,
                         title: "슈프림 양념치킨",
                         latestMemo: ["한지석", "코지"], isBookmarked: 0, isLocked: 0, isPinned: 1, createdAt: Date(), updatedAt: Date(), logMemoDates: nil, logMemoId: nil))
    }
}
