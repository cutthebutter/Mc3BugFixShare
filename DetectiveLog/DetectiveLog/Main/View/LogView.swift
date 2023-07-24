//
//  MainView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import SwiftUI
import CloudKit

struct LogView: View {
    
    @Environment(\.editMode) private var editMode
    @State var isPresented = false
    @State var isEditing = false
    @State var selection = 0
    @State var multiSelection = Set<CKRecord.ID>()
    var category = ["진행 중", "완결", "미완결"]
    
    
    @ObservedObject var viewModel = LogViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                categoryPickerView
                    .onChange(of: selection) { _ in
                        multiSelection = []
                    }
                switch selection {
                case 0:
                    inProgressLogList
                case 1:
                    completeLogList
                case 2:
                    incompleteLogList
                default:
                    Text("Error Occured")
                }
                Spacer()
            }

            .navigationTitle("사건 일지")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    if !isEditing {
                        bottomToolbarItem
                    } else {
                        bottomToolbarItemIsEditing
                    }
                    
                }
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.linear(duration: 0.2), value: isEditing)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        print("Text")
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    // EditButton을 활용하여 특정 값의 변화를 체크해서 이동하는 로직을 만들어야 할듯!
                    Menu {
                        Button {
                            self.isEditing.toggle()
                            if isEditing {
                                    
                            }
                        } label: {
                            Text(isEditing ? "Done" : "Edit")
                        }

                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
//                CategoryView(tempLog: $tempLog, temp: $temp, isPresented: $isPresented)
                CategoryView(viewModel: viewModel, isPresented: $isPresented)
            }
        }
    }
    
    var categoryPickerView: some View {
        Picker("Picker", selection: $selection) {
            ForEach(category.indices, id: \.self) { index in
                Text(category[index])
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    var inProgressLogList: some View{
        
        List(selection: $multiSelection) {
            ForEach(viewModel.log) { log in
                if log.category == .inProgress {
                    LogCell(log: log)
                        .listRowInsets(EdgeInsets())
                        .contextMenu {
                            Button {
                                viewModel.setPinned(selectedLog: log, isPinned: log.isPinned)
                            } label: {
                                Text(log.isPinned == 0 ? "상단에 고정하기" : "상단 고정 해제")
                            }
                            contextMenuItems
                        }
                }
            }
        }
        .listStyle(.inset)

    }
    
    var completeLogList: some View {
        List(selection: $multiSelection) {
            ForEach(viewModel.log) { log in
                if log.category == .complete {
                    LogCell(log: log)
                        .listRowInsets(EdgeInsets())
                        .contextMenu {
                            contextMenuItems
                        }
                }
            }
        }
        .listStyle(.inset)
    }
    
    var incompleteLogList: some View {
        List(selection: $multiSelection) {
            ForEach(viewModel.log) { log in
                if log.category == .incomplete {
                    LogCell(log: log)
                        .listRowInsets(EdgeInsets())
                        .contextMenu {
                            Button {
                                viewModel.setPinned(selectedLog: log, isPinned: log.isPinned)
                            } label: {
                                Text("상단에 고정하기")
                            }
                            contextMenuItems
                        }
                }
            }
        }
        .listStyle(.inset)
    }
//
    var bottomToolbarItem: some View {
        Group {
            Button("") {
                print("IIII")
            }
            Button {
                print("글쓰기")
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.black)
            }
        }
    }
    
    var bottomToolbarItemIsEditing: some View {
        Group {
            Button("이동") {
                viewModel.logForCategoryChange = []
                for selection in multiSelection {
                    print("@Log - \(selection)")
                    viewModel.logForCategoryChange.append(
                        viewModel.log[viewModel.log.firstIndex(where: { $0.id == selection })!]
                    )
                }
                self.isPresented.toggle()
            }
            Button {
                print("글쓰기")
                // 데이터베이스
            } label: {
                Text("삭제")
            }
        }
    }
    
    var contextMenuItems: some View {
        Group {
            
            Button {
                print("메모 잠그기")
            } label: {
                Text("메모 잠그기")
            }
            Button {
                print("이동하기")
            } label: {
                Text("이동하기")
            }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
