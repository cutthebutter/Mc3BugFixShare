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
    @State var temp: [TempLog] = []
    var category = ["진행 중", "완결", "미완결"]
    
    @State var tempLog: [TempLog] = [
        TempLog(id: UUID(), title: "질곡동 사건", createdAt: "7.17", updatedAt: "7.29", latestMemo: ["자라 한마리에 가격이 수백만원. 주변의 가게도 모두", "남자한테 좋다."], isPinned: true, category: LogCategory(rawValue: 0)!),
        TempLog(id: UUID(), title: "자라 절도 사건", createdAt: "7.17", updatedAt: "7.17", latestMemo: ["방이 어지럽혀져 있고 문이 열려있다. 황금 파리가 꼬인 것으로 보아 사망한지 6일정도 지난듯 함"], isPinned: true, category: LogCategory(rawValue: 1)!),
        TempLog(id: UUID(), title: "구소산 추락사건", createdAt: "7.17", updatedAt: "7.29", latestMemo: ["자라 한마리에 가격이 수백만원. 주변의 가게도 모두", "남자한테 좋다."], isPinned: false, category: LogCategory(rawValue: 1)!),
        TempLog(id: UUID(), title: "구소산 추락사건", createdAt: "7.17", updatedAt: "7.29", latestMemo: ["자라 한마리에 가격이 수백만원. 주변의 가게도 모두", "남자한테 좋다."], isPinned: false, category: LogCategory(rawValue: 2)!),
        TempLog(id: UUID(), title: "정제명 장염사건", createdAt: "7.17", updatedAt: "7.29", latestMemo: ["부산 갔다와서 배아프다고 자꾸 찡찡댐", "노란 장화를 사려고 함"], isPinned: false, category: LogCategory(rawValue: 0)!)
    ]
    
    
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
                    LogCell(log: log, tempLog: tempLog[0])
                        .listRowInsets(EdgeInsets())
                }
            }
        }
        .listStyle(.inset)
    }
    
    var completeLogList: some View {
        List(selection: $multiSelection) {
            ForEach(viewModel.log) { log in
                if log.category == .complete {
                    LogCell(log: log, tempLog: tempLog[0])
                        .listRowInsets(EdgeInsets())
                }
            }
        }
        .listStyle(.inset)
    }
    
    var incompleteLogList: some View {
        List(selection: $multiSelection) {
            ForEach(viewModel.log) { log in
                if log.category == .incomplete {
                    LogCell(log: log, tempLog: tempLog[0])
                        .listRowInsets(EdgeInsets())
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
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
