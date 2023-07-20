//
//  MainView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import SwiftUI

struct MainView: View {
    @State var selection = "진행 중"
    @State var multiSelection = Set<UUID>()
    var category = ["진행 중", "완결", "미완결"]
    
    var tempLog: [TempLog] = [
        TempLog(id: UUID(), title: "질곡동 사건", createdAt: "7.17", updatedAt: "7.29", latestMemo: ["자라 한마리에 가격이 수백만원. 주변의 가게도 모두", "남자한테 좋다."], isPinned: true),
        TempLog(id: UUID(), title: "자라 절도 사건", createdAt: "7.17", updatedAt: "7.17", latestMemo: ["방이 어지럽혀져 있고 문이 열려있다. 황금 파리가 꼬인 것으로 보아 사망한지 6일정도 지난듯 함"], isPinned: true),
        TempLog(id: UUID(), title: "구소산 추락사건", createdAt: "7.17", updatedAt: "7.29", latestMemo: ["자라 한마리에 가격이 수백만원. 주변의 가게도 모두", "남자한테 좋다."], isPinned: false),
        TempLog(id: UUID(), title: "구소산 추락사건", createdAt: "7.17", updatedAt: "7.29", latestMemo: ["자라 한마리에 가격이 수백만원. 주변의 가게도 모두", "남자한테 좋다."], isPinned: false),
        TempLog(id: UUID(), title: "정제명 장염사건", createdAt: "7.17", updatedAt: "7.29", latestMemo: ["자라 한마리에 가격이 수백만원. 주변의 가게도 모두", "남자한테 좋다."], isPinned: false)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                categoryPickerView
                logList
            }
            .navigationTitle("사건 일지")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        print("Text")
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    // EditButton을 활용하여 특정 값의 변화를 체크해서 이동하는 로직을 만들어야 할듯!
                    Menu {
                        EditButton()
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
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
    }
    
    var categoryPickerView: some View {
        Picker("Hi", selection: $selection) {
            ForEach(category, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    var logList: some View {
        // category 0, 1, 2에 맞는 무언가가 필요해~
        List(selection: $multiSelection) {
            ForEach(tempLog) { log in
                LogCell(tempLog: log)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.inset)
    }
    
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
