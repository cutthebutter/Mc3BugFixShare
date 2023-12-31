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
    @State var isLocked: Bool
    @State var isMenuPresented: Bool = false
    @State var isEditButtonClicked: Bool = false
    @State var isCreatePresented: Bool = false
    @State var isCreateButtonClicked: Bool = false
    @State var isOpinionPresented: Bool = false
    @State var isOpinionUpdateButtonClicked: Bool = false
    @State var isSearch: Bool = false
    @State var clickedCurrentMonthDates: Date?
    @State var searchText :String = ""
    @State var matchingIDs: [UUID] = []
    @State var currentIDIndex: Int?
    @State private var showingAlert = false
    
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
            
            if isSearch {
                SearchBarView(isSearch: $isSearch, clickedCurrentMonthDates: $clickedCurrentMonthDates, searchText: $searchText)
                
            }
            if isSearch {
                HStack{
                    Spacer()
                    //이전 버튼
                    Button {
                        currentIDIndex = max(currentIDIndex! - 1, 0)
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    .padding(.trailing)
                    .foregroundColor((searchText.isEmpty || currentIDIndex == 0) ? .gray.opacity(0.5) : .black)
                    .disabled(searchText.isEmpty || currentIDIndex == 0)
                    
                    //디음 버튼
                    Button {
                        currentIDIndex = min(currentIDIndex! + 1, matchingIDs.count - 1)
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    .padding(.trailing)
                    .foregroundColor((searchText.isEmpty || currentIDIndex == matchingIDs.count - 1) ? .gray.opacity(0.5) : .black)
                    .disabled(searchText.isEmpty || currentIDIndex == matchingIDs.count - 1)
                    
                }
                .padding(.vertical)
                .background(Color.white)
                
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                backButton
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                searchButton
                    .disabled(logIsEmpty)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                detailMenuButton
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
        //MARK: 새로 메모 입력 후 수정 시 안됨. 각각은 된다.. 이유는 모르겠음
        .sheet(isPresented: $isMenuPresented) { // 일지 탭 할 경우 수정 - 삭제 열기
            DetailLogMenuSheet(viewModel: viewModel,
                               logMemo: $viewModel.detailLog[viewModel.detailLogIndex].logMemo[viewModel.logMemoIndex],
                               isPresented: $isMenuPresented,
                               isEditButtonClicked: $isEditButtonClicked)
            .presentationDetents([.height(247)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isCreatePresented) { // 새로운 일지 작성
            LogWriteSheet(writeType: .memo,
                          text: $viewModel.newMemo,
                          isPresented: $isCreatePresented,
                          isFinishButtonClicked: $isCreateButtonClicked)
            .presentationDetents([.height(247)])
        }
        .sheet(isPresented: $isOpinionPresented) { // 사견 탭 클릭
            LogWriteSheet(writeType: .opinion,
                          text: $viewModel.detailLog[viewModel.detailLogIndex].logOpinion.opinion,
                          isPresented: $isOpinionPresented,
                          isFinishButtonClicked: $isOpinionUpdateButtonClicked)
            .presentationDetents([.height(247)])
        }
        // 작성한 메모는 recordID와 referenceId가 없기에 일어나는 일
        .onChange(of: isCreateButtonClicked) { _ in
            if let log = viewModel.log {
                let today = Calendar.current.startOfDay(for: Date())
                Task {
                    await viewModel.createLogMemo(log: log,
                                                  memo: viewModel.newMemo,
                                                  status: viewModel.detailLog.contains(where: { $0.date == today }) ? .exist : .new)
                    viewModel.newMemo = ""
                }
            }
        }
        .onChange(of: isEditButtonClicked) { _ in
            print("@Log is EditButtonClicked")
            viewModel.updateLogMemo(logMemo: viewModel.detailLog[viewModel.detailLogIndex].logMemo[viewModel.logMemoIndex])
        }
        .onChange(of: isOpinionUpdateButtonClicked) { _ in
            viewModel.updateLogOpinion(logOpinion: viewModel.detailLog[viewModel.detailLogIndex].logOpinion)
        }
        .onChange(of: searchText) { newValue in
            matchingIDs.removeAll()
            for detailLog in viewModel.detailLog {
                for logMemo in detailLog.logMemo {
                    if logMemo.memo.contains(newValue) {
                        matchingIDs.append(logMemo.id)
                    }
                }
            }
            currentIDIndex = matchingIDs.isEmpty ? nil : 0
            if matchingIDs.isEmpty {
                showingAlert = true
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
                        MemoCell(logMemo: viewModel.detailLog[dataIndex].logMemo[memoIndex], isMatching: matchingIDs.contains(viewModel.detailLog[dataIndex].logMemo[memoIndex].id))
                            .id(viewModel.detailLog[dataIndex].logMemo[memoIndex].id)
                            .onTapGesture {
                                viewModel.detailLogIndex = dataIndex
                                viewModel.logMemoIndex = memoIndex
                                isMenuPresented.toggle()
                            }
                    }
                    OpinionCell(logOpinion: viewModel.detailLog[dataIndex].logOpinion)
                        .onTapGesture {
                            viewModel.detailLogIndex = dataIndex
                            isOpinionPresented.toggle()
                        }
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparatorTint(.white)
            }
            .listStyle(.plain)
            .onChange(of: viewModel.lastIndex) { _ in
                list.scrollTo(viewModel.lastIndex)
                
            }
            .onChange(of: clickedCurrentMonthDates) { newValue in
                if let date = newValue {
                    let dateString = formatDateToStringYyyyMdd(date: date)
                    list.scrollTo(dateString, anchor: .top)
                }
            }
            .onChange(of: currentIDIndex) { newValue in
                if let index = newValue {
                    list.scrollTo(matchingIDs[index], anchor: .top)
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
    
    var searchButton: some View {
        Button{
            isSearch = true
        } label : {
            Image(systemName: "magnifyingglass")
        }
    }
    
    var detailMenuButton: some View {
        Button {
            //TODO: detailMenuButton
        } label: {
            Image("ellipsis.circle")
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
                        self.isCreatePresented.toggle()
                    } label: {
                        HStack(spacing: 0) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.black)
                                .padding(.trailing, 10)
                            Text("단서추가")
                                .font(.custom("AppleSDGothicNeo-SemiBold", size: 20))
                                .foregroundColor(.black)
                        }
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
    
    func formatDateToStringYyyyMdd(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. M. dd"
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
