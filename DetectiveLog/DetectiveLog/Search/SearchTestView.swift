//
//  SearchTestView.swift
//  DetectiveLog
//
//  Created by semini on 2023/07/25.
//

import SwiftUI

@available(iOS 16.0, *)
struct SearchTestView: View {
    @ObservedObject var viewModel = SearchTestViewModel()
    @State var isSearch : Bool = false
    @State var clickedCurrentMonthDates: Date?
    @State var searchText :String = ""
    @State var matchingIDs: [UUID] = []
    @State var currentIDIndex: Int?
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView{
            ZStack {
                ScrollViewReader { proxy in
                    List{
                        ForEach(groupData(viewModel.logMemoList), id: \.key) { key, values in
                            Section(header: Text("\(key)")) {
                                ForEach(values) { log in
                                    memoCell(fakeLogMemo: log, searchText : $searchText)
                                        .id(log.id)
                                        .onAppear {
                                            if log.content.contains(searchText) && !matchingIDs.contains(log.id) {
                                                matchingIDs.append(log.id)
                                            }
                                        }
                                    
                                }
                            }
                        }
                    }
                    .padding(.top, isSearch ? 66 : 0) ///검색시 searchBar보다 아래에 스크롤뷰가 위치하기 위함
                    .onChange(of: clickedCurrentMonthDates) { newValue in
                        let dateKey = getFormattedDateKey(newValue)
                        withAnimation {
                            proxy.scrollTo(dateKey, anchor: .top)
                        }
                    }
                    .onChange(of: searchText) { newValue in
                        matchingIDs = viewModel.logMemoList.filter { $0.content.contains(newValue) }.map { $0.id }
                        currentIDIndex = nil
                        ///찾는 데이터가 없을 때 Alert을 표시하기 위함
                        if !newValue.isEmpty, matchingIDs.isEmpty {
                            showingAlert = true
                            searchText = ""
                        }
                    }
                    if isSearch {
                        HStack{
                            Spacer()
                            //이전 버튼
                            Button {
                                if let currentIndex = currentIDIndex, currentIndex - 1 >= 0 {
                                    currentIDIndex = currentIndex - 1
                                } else {
                                    currentIDIndex = matchingIDs.count - 1
                                }
                                if let currentIndex = currentIDIndex {
                                    withAnimation {
                                        proxy.scrollTo(matchingIDs[currentIndex], anchor: .top)
                                    }
                                }
                            } label: {
                                Image(systemName: "chevron.up")
                            }
                            .padding(.trailing)
                            .foregroundColor((searchText.isEmpty || currentIDIndex == 0) ? .gray.opacity(0.5) : .black)
                            .disabled(searchText.isEmpty || currentIDIndex == 0)
                            
                            //디음 버튼
                            Button {
                                if let currentIndex = currentIDIndex, currentIndex + 1 < matchingIDs.count {
                                    currentIDIndex = currentIndex + 1
                                } else {
                                    currentIDIndex = 0
                                }
                                if let currentIndex = currentIDIndex {
                                    withAnimation {
                                        proxy.scrollTo(matchingIDs[currentIndex], anchor: .top)
                                    }
                                }
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
                if isSearch { ///서치바뷰가 Z스택으로 쌓임
                    SearchBarView(isSearch: $isSearch, clickedCurrentMonthDates: $clickedCurrentMonthDates, searchText: $searchText)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if isSearch != true {
                        Button { //
                            isSearch = true //
                        } label: { //
                            Image("magnifyingglass") //
                        } //
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if isSearch != true {
                        Button { //
                            
                        } label: { //
                            Image(systemName: "ellipsis.circle.fill") //
                        }
                    }
                }
            }
            .alert(isPresented: $showingAlert) {  // Alert를 사용
                Alert(title: Text("찾는 데이터가 없습니다."), dismissButton: .default(Text("확인")))
            }
        }
    }
    
    /// 섹션을 그룹화 함
    func groupData(_ data: [FakeLogMemo]) -> [(key: String, value: [FakeLogMemo])] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let grouped = Dictionary(grouping: data) { (element: FakeLogMemo) in
            dateFormatter.string(from: element.date)
        }
        return grouped.sorted { $0.key < $1.key }
    }
    
    func getFormattedDateKey(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
}
//MARK: - 메모셀 :리스트를 구성함
struct memoCell : View {
    @State var fakeLogMemo : FakeLogMemo
    @Binding var searchText : String
    var body : some View {
        HStack {
            Text(getHHmmFormat(fakeLogMemo.date))
                .padding(.horizontal)
            Text(fakeLogMemo.content)
                .foregroundColor(fakeLogMemo.content.contains(searchText) ? .blue : .primary)
        }
    }
    //메모 셀 안의 데이터 포맷
    func getHHmmFormat(_ date : Date) -> String {
        let date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        return timeString
    }
}



//struct SearchTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            SearchTestView()
//        }
//    }
//}
