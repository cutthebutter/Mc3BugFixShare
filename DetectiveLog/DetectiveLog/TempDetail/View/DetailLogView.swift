//
//  DetailLogView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct DetailLogView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isKeyboardVisible: Bool = false
    @State private var logIsEmpty: Bool = false
    @State var isLocked: Bool
    @State var isMenuPresented: Bool = false
    @State var isEditButtonClicked: Bool = false
    @State var isCreatePresented: Bool = false
    @State var isCreateMemoClicked: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                title
                if isLocked {
                    faceIdView
                    Spacer()
                } else {
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
                        .frame(height: 55)
                }
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
            if isLocked {
                viewModel.detailLogIsLocked { success in
                    if success { // Face ID 인증이 성공적으로 진행되었을 때 isLocked = false로 화면 변화
                        isLocked = false
                    } else {
                        isLocked = true
                    }
                }
            }
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
        .sheet(isPresented: $isMenuPresented) {
            DetailLogMenuSheet(logMemo: $viewModel.detailLog[viewModel.detailLogIndex].logMemo[viewModel.logMemoIndex],
                               isPresented: $isMenuPresented,
                               isEditButtonClicked: $isEditButtonClicked)
            .presentationDetents([.height(247)])
        }
        .sheet(isPresented: $isCreatePresented) {
            LogMemoWriteView(logMemo: $viewModel.detailLog[viewModel.detailLogIndex].logMemo[viewModel.logMemoIndex],
                             isPresented: $isCreatePresented,
                             isEditButtonClicked: $isEditButtonClicked,
                             memo: $viewModel.newMemo)
            .presentationDetents([.height(247)])
        }
        .onChange(of: isEditButtonClicked) { _ in
            viewModel.updateLogMemo(logMemo: viewModel.detailLog[viewModel.detailLogIndex].logMemo[viewModel.logMemoIndex])
            isEditButtonClicked = false
        }
        .onChange(of: isCreateMemoClicked) { _ in
            if let log = viewModel.log {
                let today = Calendar.current.startOfDay(for: Date())
                if viewModel.detailLog.contains(where: { $0.date == today }) {
                    viewModel.createLogMemo(log: log, memo: "isExist", status: .exist)
                    print("@Log create Exist")
                } else {
                    viewModel.createLogMemo(log: log, memo: "isEmpty", status: .new)
                    print("@Log create New")
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
                TextField("사건일지를 입력하세요.", text: $0.title)
                    .font(.custom("AppleSDGothicNeo-Bold", size: 22))
                    .padding(.top, 16)
                    .padding(.leading, 20)
                    .onSubmit {
                        viewModel.updateLogTitle()
                    }
            }
        }
        
    }
    
    var faceIdView: some View {
        VStack(spacing: 0) {
            Image("lock.fill")
                .padding(.top, 128)
            Text("이 사건의 단서를 보려면\n Face ID를 사용하십시오.")
                .font(.custom("AppleSDGothicNeo-SemiBold", size: 20))
                .multilineTextAlignment(.center)
                .padding(.top, 32)
            
        }
    }
    
    var combineLogCell: some View {
        ScrollViewReader { list in
            List {
                ForEach(viewModel.detailLog.indices, id: \.self) { dataIndex in
                    DateCell(detailLog: viewModel.detailLog[dataIndex])
                    ForEach(viewModel.detailLog[dataIndex].logMemo.indices, id: \.self) { memoIndex in
                        MemoCell(logMemo: viewModel.detailLog[dataIndex].logMemo[memoIndex])
                            .id(viewModel.detailLog[dataIndex].logMemo[memoIndex].id)
                            .onTapGesture {
                                viewModel.detailLogIndex = dataIndex
                                viewModel.logMemoIndex = memoIndex
                                withAnimation {
                                    isMenuPresented.toggle()
                                }
                                
                            }
                    }
                    OpinionCell(logOpinion: viewModel.detailLog[dataIndex].logOpinion)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparatorTint(.white)
            }
            .listStyle(.plain)
            .onChange(of: viewModel.lastIndex) { _ in
                list.scrollTo(viewModel.lastIndex)
                
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
            .frame(height: 82)
            .overlay(alignment: .top) {
                HStack(alignment: .top, spacing: 0) {
                    Spacer()
                    Button {
                        if let log = viewModel.log {
                            let today = Calendar.current.startOfDay(for: Date())
                            if viewModel.detailLog.contains(where: { $0.date == today }) {
                                viewModel.createLogMemo(log: log, memo: "isExist", status: .exist)
                                print("@Log create Exist")
                            } else {
                                viewModel.createLogMemo(log: log, memo: "isEmpty", status: .new)
                                print("@Log create New")
                                
                            }
                        }
//                        self.isCreatePresented.toggle()
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
            viewModel.updateLogTitle()
        }
    }
    
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
