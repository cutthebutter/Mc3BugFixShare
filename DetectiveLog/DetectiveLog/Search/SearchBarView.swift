//
//  SearchBarView.swift
//  DetectiveLog
//
//  Created by semini on 2023/07/25.
//

import SwiftUI
import Combine

//@available(iOS 16.0, *)

struct SearchBarView: View {
    @State var searchInput = ""
    @Binding var isSearch : Bool
    @State var showCalendar = false
    @Binding var clickedCurrentMonthDates: Date?
    @Binding var searchText : String
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    HStack{
                        Image(systemName: "magnifyingglass")
                        TextField("사건 실마리 찾아보기", text: $searchInput) {
                            searchText = searchInput
                        }
                        if searchInput.count == 0 {
                            // 캘린더 버튼
                            Button{
                                showCalendar = true
                            } label : {
                                Image(systemName: "calendar")
                            }
                        } else {
                            // 버튼(검색키워드를 삭제함)
                            Button{
                                searchInput = ""
                                searchText = ""
                                
                            } label : {
                                Image(systemName: "x.circle.fill")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 50) // 둥근 사각형 생성
                            .stroke(Color.black, lineWidth: 1)
                    )
                    // 취소버튼
                    Button{
                        isSearch = false
                        searchText = ""
                    } label :{
                        Text("취소")
                    }
                }
                .foregroundColor(Color.black)
                .padding()
                .background(Color.white)
                Spacer()
            }

        }
        .sheet(isPresented: $showCalendar) {
            CalendarView(clickedCurrentMonthDates: $clickedCurrentMonthDates, showCalendar : $showCalendar)
                .padding()
                .presentationDetents([.fraction(0.45)])
        }
    }
}

//struct SearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarView(isSearch: true)
//    }
//}
