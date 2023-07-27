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
        NavigationView {
            VStack(spacing: 0) {
                title
                if viewModel.detailLog == [] {
                    VStack(alignment: .center) {
                        ProgressView()
                    }
                }
                combineLogCell
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("testBtn") {
                        // 테스트용 입니다.
                    }
                    Button {
                        if let log = viewModel.log {
                            viewModel.createLogMemo(log: log, memo: "홍산오의 전 여자친구와 관련 있는듯함")
                        }
                    } label: {
                        Text("단서추가")
                            .font(.custom("AppleSDGothicNeo-SemiBold", size: 20))
                            .foregroundColor(.black)
                            
                    }
                }
            }
            .onTapGesture {
                endEditing()
            }
            .onAppear {
                if let log = viewModel.log {
                    Task {
                        await viewModel.fetchLogData(log: log)
                    }
                } else {
                    viewModel.createLog()
                }
            }
        }
    }
    
    var title: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(.white)
                .frame(height: 66)
                .frame(maxWidth: .infinity)
            
            Binding($viewModel.log).map {
                TextField("", text: $0.title)
                    .font(.custom("AppleSDGothicNeo-Bold", size: 22))
                    .padding(.top, 16)
                    .padding(.leading, 20)
            }
        }
        
    }
    
    
    var combineLogCell: some View {
        ScrollViewReader { list in
            List {
                ForEach(viewModel.detailLog.indices, id: \.self) { dataIndex in
                        DateCell(detailLog: viewModel.detailLog[dataIndex])
                    VStack(spacing: 0) {
                        ForEach(viewModel.detailLog[dataIndex].logMemo.indices, id: \.self) { memoIndex in
                            MemoCell(logMemo: viewModel.detailLog[dataIndex].logMemo[memoIndex])
                        }
                    }
                        OpinionCell(logOpinion: viewModel.detailLog[dataIndex].logOpinion)
                            .id(viewModel.detailLog[dataIndex].logOpinion.id)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparatorTint(.white)
            }
            .listStyle(.plain)
            .onChange(of: viewModel.lastIndex) { _ in
                withAnimation {
                    list.scrollTo(viewModel.lastIndex)
                }
            }
        }
    }

    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: date)
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

