//
//  DetailLogView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/26.
//

import SwiftUI

struct DetailLogView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isKeyboardVisible: Bool = false
    @State private var logIsEmpty: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                title
                if viewModel.detailLog == [] {
                    VStack(alignment: .center) {
                        if !logIsEmpty {
                            Spacer()
                            ProgressView()
                        } else {
                            Image("glass")
                                .padding(.top, 126)
                            Text("아직 단서가 없네요!\n단서를 추가해주세요.")
                                .multilineTextAlignment(.center)
                                .font(.custom("AppleSDGothicNeo-SemiBold", size: 20))
                                .opacity(0.2)
                                .frame(height: 64)
                                .lineLimit(2)
                                .padding(.top, 34)
                                
                        }
                    }
                }
                combineLogCell
                Rectangle()
                    .fill(.white)
                    .frame(height: 51)
            }
            VStack {
                Spacer()
                Divider()
                bottomBar
            }
            .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .navigationBarBackButtonHidden()
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            self.isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            self.isKeyboardVisible = false
        }
        .onTapGesture {
            endEditing()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                self.logIsEmpty = true
            }
            if let log = viewModel.log {
                Task {
                    await viewModel.fetchLogData(log: log)
                }
            } else {
                viewModel.createLog()
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
                TextField("사건일지를 입력하세요.", text: $0.title)
                    .font(.custom("AppleSDGothicNeo-Bold", size: 22))
                    .padding(.top, 16)
                    .padding(.leading, 20)
                    .onSubmit {
//                        viewModel.updateLogTitle()
                    }
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
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("backButton")
        }
    }
    
    var bottomBar: some View {
        Rectangle()
            .fill(.white)
            .frame(height: 85)
            .overlay(alignment: .top) {
                HStack(alignment: .top, spacing: 0) {
                    Spacer()
                    Button {
                        if let log = viewModel.log {
                            if viewModel.detailLog.isEmpty {
//                                viewModel.createLogMemo(log: log, memo: "isEmpty", status: .new)
                                viewModel.createLogMemo(log: log, memo: "isEmpty")
                            } else {
//                                viewModel.createLogMemo(log: log, memo: "isEmpty", status: .exist)
                                viewModel.createLogMemo(log: log, memo: "isEmpty")
                            }
                        }
                    } label: {
                        Text("단서추가")
                            .font(.custom("AppleSDGothicNeo-SemiBold", size: 20))
                            .foregroundColor(.black)
                    }
                    .padding(.top, 13)
                    .padding(.trailing, 20)
                }
            }
    }
    
    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: date)
    }
    
    private func endEditing() {
        if isKeyboardVisible {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//            viewModel.updateLogTitle()
        }
    }
    
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
