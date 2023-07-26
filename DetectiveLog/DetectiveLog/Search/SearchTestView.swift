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
    
    var body: some View {
        NavigationView{
            ZStack {
                List{
                    ForEach(groupData(viewModel.logMemoList), id: \.key) { key, values in
                        Section(header: Text("\(key)")) {
                            ForEach(values) { log in
                                memoCell(fakeLogMemo: log)
                            }
                        }
                    }
                }
                .padding(.top, isSearch ? 44 : 0)
                
                if isSearch {
                    SearchBarView(isSearch: $isSearch)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if isSearch != true {
                        Button {
                            isSearch = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }

                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if isSearch != true {
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                        }
                    }
                }
                
            }
        }
  
    }
    /// 섹션을 그룹화 함
    func groupData(_ data: [FakeLogMemo]) -> [(key: String, value: [FakeLogMemo])] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let grouped = Dictionary(grouping: data) { (element: FakeLogMemo) in
            dateFormatter.string(from: element.date)
        }
        return grouped.sorted { $0.key < $1.key }
    }
}

struct memoCell : View {
    @State var fakeLogMemo : FakeLogMemo
    var body : some View {
        HStack {
            Text(getHHmmFormat(fakeLogMemo.date))
                .padding(.horizontal)
            Text(fakeLogMemo.content)
        }
    }
    
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
