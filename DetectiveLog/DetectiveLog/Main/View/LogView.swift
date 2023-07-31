//
//  MainView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import SwiftUI
import CloudKit
import LocalAuthentication

///MARK: 네비게이션 뷰 전환 후 다시 메인뷰로 돌아왔을 때 뷰가 전체적으로 내려가고, 그 상태에서 다른 뷰로 전환 시 데이터가 안넘어가는 버그가 있음.
@available(iOS 16.0, *)
struct LogView: View {
    
    @Environment(\.editMode) var editMode
    @State var isPresented = false
    @State var isEditing = false
    @State var selection = 0
    @State var multiSelection = Set<UUID>()
    var category = ["진행 중", "완결", "미완결"]
    let faceIDManager = FaceIDManager()
    
    @ObservedObject var viewModel = LogViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                title
                categoryPickerView
                    .onChange(of: selection) { _ in
                        viewModel.logForCategoryChange = []
                        multiSelection = []
                    }
                switch selection {
                case 0:
                    logList(category: .inProgress)
                case 1:
                    logList(category: .complete)
                case 2:
                    logList(category: .incomplete)
                default:
                    Text("Error Occured")
                }
                Spacer()

            }
            .sheet(isPresented: $isPresented) {
                CategoryView(viewModel: viewModel, isPresented: $isPresented)
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
            .animation(Animation.linear(duration: 0.2), value: isEditing)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
//                        faceIDManager.authenticate(log: viewModel.log[2])
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                    // EditButton을 활용하여 특정 값의 변화를 체크해서 이동하는 로직을 만들어야 할듯!
                    Menu {
                        Button {
                            self.isEditing.toggle()
                        } label: {
                            Text(isEditing ? "Done" : "선택하기")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    if !isEditing {
                        bottomToolbarItem
                    } else {
                        bottomToolbarItemIsEditing
                    }

                }
            }
            .onAppear {
                print("@main On Appear")
                viewModel.fetchLog()
            }
            .navigationViewStyle(.stack)
        }
    }
    
    //MARK: Title
    
    var title: some View {
        Rectangle()
            .fill(.clear)
            .frame(height: 66)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topLeading) {
                Text("사건 일지")
                    .font(.custom("AppleSDGothicNeo-Bold", size: 22))
                    .padding(.top, 16)
                    .padding(.leading, 20)
            }
    }
    
    //MARK: PickerView
    
    var categoryPickerView: some View {
        Picker("Picker", selection: $selection) {
            ForEach(category.indices, id: \.self) { index in
                Text(category[index])
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 20)
    }
    
    //MARK: Bottom Toolbar - 바텀 툴바. 디폴트 & Editing시 Bottom Toolbar
    
    var bottomToolbarItem: some View {
        Group {
            NavigationLink {
                EmptyView()
            } label: {
                EmptyView()
            }
            .opacity(0)
            
            NavigationLink {
                DetailLogView(viewModel: DetailViewModel(log: nil,
                                                          logCount: viewModel.log.count + 1),
                              isLocked: false)
            } label: {
                Image("write")
                    .foregroundColor(.black)
            }
        }
    }
    
    var bottomToolbarItemIsEditing: some View {
        Group {
            Button {
                viewModel.logForCategoryChange = []
                for selection in multiSelection {
                    print("@Log - \(selection)")
                    if let index = viewModel.log.firstIndex(where: { $0.id == selection }) {
                        viewModel.logForCategoryChange.append(viewModel.log[index])
                    }
                }
                self.isPresented.toggle()
            } label: {
                Text("재분류하기")
                    .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                    .foregroundColor(.black)
            }
            Button {
                print("글쓰기")
                // 데이터베이스
            } label: {
                Text("삭제하기")
                    .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                    .foregroundColor(.red)
            }
        }
    }
    
    //MARK: Log List - 카테고리 별 리스트
//        .indices, id: \.self
    /// List EditMode는 ID가 옵셔널일 경우 작동하지 않음. id는 무조건 있어야 함.!

    func logList(category: LogCategory) -> some View {
        return List(selection: $multiSelection) {
            ForEach(viewModel.log) { log in
                if log.category == category {
                    ZStack {
                        NavigationLink {
                            // 사건일지가 잠겼을 때, faceID로 true를 반환받은 후에야 뷰를 띄워줘야 함. 어떻게?
                            if log.isLocked == 1 {
                                DetailLogView(viewModel: DetailViewModel(log: log,
                                                                         logCount: viewModel.log.count),
                                              isLocked: true)
                            } else {
                                DetailLogView(viewModel: DetailViewModel(log: log,
                                                                         logCount: viewModel.log.count),
                                              isLocked: false)
                            }
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        LogCell(log: log)
                            .contextMenu {
                                setPinnedButton(log: log)
                                categoryChangeButton(log: log)
                                isLockedButton(log: log)
                            }
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
        }
        .padding(.top, 12)
        .listStyle(.inset)

    }
    
    //MARK: Context Menu - 꾹 눌렀을 때 나오는 메뉴
    
    func setPinnedButton(log: Log) -> some View {
        return Button {
            viewModel.setPinned(selectedLog: log, isPinned: log.isPinned)
        } label: {
            Text(log.isPinned == 0 ? "상단에 고정하기" : "상단 고정 해제")
        }
    }
    
    func categoryChangeButton(log: Log) -> some View {
        return Button {
            viewModel.logForCategoryChange.append(log)
            isPresented.toggle()
        } label: {
            Text("이동하기")
        }
    }
    
    func isLockedButton(log: Log) -> some View {
        return Button {
            viewModel.updateIsLocked(selectedLog: log)
        } label: {
            Text(log.isLocked == 0 ? "메모 잠그기" : "메모 잠금해제")
        }
    }
    
    var contextMenuItems: some View {
        Group {
            Button {
                print("메모 잠그기")
            } label: {
                Text("메모 잠그기")
            }
        }
    }
    

    
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogView()
//    }
//}
