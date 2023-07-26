//
//  MainView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import SwiftUI
import CloudKit

struct LogView: View {
    
    @Environment(\.editMode) var editMode
    @State var isPresented = false
    @State var isEditing = false
    @State var selection = 0
    @State var multiSelection = Set<UUID>()
    var category = ["진행 중", "완결", "미완결"]
    
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
                        print("Text")
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
//        .padding()
    }
    
    //MARK: Bottom Toolbar - 바텀 툴바. 디폴트 & Editing시 Bottom Toolbar
    
    var bottomToolbarItem: some View {
        Group {
            Button("") {
                print("IIII")
            }
            NavigationLink {
                TempView(logCount: viewModel.log.count)
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
                    viewModel.logForCategoryChange.append(
                        viewModel.log[viewModel.log.firstIndex(where: { $0.id == selection })!]
                    )
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

    func logList(category: LogCategory) -> some View {
        return List(selection: $multiSelection) {
            ForEach(viewModel.log) { log in
                if log.category == category {
                    LogCell(log: log)
                        .listRowInsets(EdgeInsets())
                        .contextMenu {
                            setPinnedButton(log: log)
                            categoryChangeButton(log: log)
                            contextMenuItems
                        }
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
