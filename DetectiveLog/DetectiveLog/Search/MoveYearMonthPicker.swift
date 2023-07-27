//
//  MoveYearMonthPicker.swift
//  DetectiveLog
//
//  Created by semini on 2023/07/26.
//

import SwiftUI

struct MoveYearMonthPicker: View {
    @ObservedObject var viewModel = SearchTestViewModel()
    @Binding var month : Date
    @Binding var isMonthChange : Bool
    @State private var selectedYear: String = String(format: "%d년", Calendar.current.component(.year, from: Date()))
    @State private var selectedMonth: String = String(format: "%d월", Calendar.current.component(.month, from: Date()))
    
    let startYear: Int
    let startMonth : Int
    let endYear: Int
    let endMonth: Int
    let allYears: [String]
    let allMonths: [String] = Array(1...12).map { String(format: "%d월", $0) }
    
    init(month: Binding<Date>, isMonthChange: Binding<Bool>, viewModel: SearchTestViewModel) {
            self._month = month
            self._isMonthChange = isMonthChange
            self.viewModel = viewModel

            if let firstDate = viewModel.logMemoList.first?.date,
               let lastDate = viewModel.logMemoList.last?.date {
                startYear = Calendar.current.component(.year, from: firstDate)
                startMonth = Calendar.current.component(.month, from: firstDate)
                endYear = Calendar.current.component(.year, from: lastDate)
                endMonth = Calendar.current.component(.month, from: lastDate)
            } else {
                startYear = Calendar.current.component(.year, from: Date())
                startMonth = Calendar.current.component(.month, from: Date())
                endYear = startYear
                endMonth = startMonth
            }
                
            allYears = Array(startYear...endYear).map { String(format: "%d년", $0) }
        }
    
    var availableMonths: [String] {
        if endYear == startYear {
            return Array(allMonths[(startMonth-1)...(endMonth-1)])
        } else if selectedYear == String(format: "%d년", endYear) {
            return Array(allMonths[0...(endMonth-1)])
        } else if selectedYear == String(format: "%d년", startYear){
            return Array(allMonths[(startMonth-1)...])
        } else {
            return allMonths
        }
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Picker("Year", selection: $selectedYear) {
                    ForEach(allYears, id: \.self) { year in
                        Text(year).tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .onChange(of: selectedYear) { newValue in
                    if newValue == String(format: "%d년", startYear) && availableMonths.last! < selectedMonth {
                        selectedMonth = availableMonths.last!
                    }
                }

                Picker("Month", selection: $selectedMonth) {
                    ForEach(availableMonths, id: \.self) { month in
                        Text(month).tag(month)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .onChange(of: selectedYear) { _ in
                    if availableMonths.last! < selectedMonth {
                        selectedMonth = availableMonths.last!
                    }
                }
            }
            HStack{     
                Button {
                    isMonthChange = false

                } label: {
                    HStack{
                        Spacer()
                        Text("취소")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(red: 244/255, green: 244/255, blue: 245/255))
                    )
                }
                    
                Button {
                    if let (year, month) = parseSelectedYearAndMonth() {
                        var dateComponents = DateComponents()
                        dateComponents.year = year
                        dateComponents.month = month
                        
                        if let selectedDate = Calendar.current.date(from: dateComponents) {
                            self.month = selectedDate
                        }
                    }
                    isMonthChange = false
                } label: {
                    HStack{
                        Spacer()
                        Text("완료")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(red: 244/255, green: 244/255, blue: 245/255))
                    )
                }
                
            }

        }
        .padding()
    }
    
    func parseSelectedYearAndMonth() -> (Int, Int)? {
        guard let year = Int(selectedYear.dropLast(1)),
              let month = Int(selectedMonth.dropLast(1)) else {
            return nil
        }
        
        return (year, month)
    }
    
}

//struct MoveYearMonthPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        MoveYearMonthPicker()
//    }
//}
