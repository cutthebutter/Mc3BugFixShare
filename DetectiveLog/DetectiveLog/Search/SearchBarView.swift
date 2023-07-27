//
//  SearchBarView.swift
//  DetectiveLog
//
//  Created by semini on 2023/07/25.
//

import SwiftUI

@available(iOS 16.0, *)

struct SearchBarView: View {
    @State var searchText = ""
    @Binding var isSearch : Bool
    @State var showCalendar = false
    @Binding var clickedCurrentMonthDates: Date?
    
    var body: some View {
        VStack{
            HStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("사건 실마리 찾아보기", text: $searchText)
                    if searchText.count == 0 {
                        Button{
                            showCalendar = true
                        } label : {
                            Image(systemName: "calendar")
                        }
                    } else {
                        Button{
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
                
                Button{
                    isSearch = false
                } label :{
                    Text("취소")
                    
                }
            }
            .foregroundColor(Color.black)
            .padding()
            .background(Color.white)

            Spacer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    
                } label: {
                    Text("")
                }
                HStack{
                    Button {
                        print("UP")
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    Button {
                        print("DOWN")
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                }
                
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
