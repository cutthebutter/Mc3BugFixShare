//
//  LogListView.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/24.
//

import SwiftUI

//struct LogListView: View {
//    @ObservedObject var viewModel : LogListViewModel
//    
//    var body: some View {
//        NavigationView{
//            List{
//                ForEach(groupData(viewModel.fakeEachLog), id: \.0) { key, values in
//                    Section(header: Text("\(key)")) {
//                        ForEach(values) { log in
//                            NavigationLink{
//                                LogDetailView(fakeEachLog: log)
//                            } label :{
//                                Text(log.contents)
//                                    .lineLimit(3)
//                            }
//                            
//                        }
//                    }
//                }
//                
//            }
//            .navigationTitle("단서록")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//    
//    func groupData(_ data: [FakeEachLog]) -> [(key: String, value: [FakeEachLog])] {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yy.MM.dd"
//        
//        let grouped = Dictionary(grouping: data) { (element: FakeEachLog) in
//            dateFormatter.string(from: element.date)
//        }
//        return grouped.sorted { $0.key > $1.key }
//    }
//}
//
////struct LogListView_Previews: PreviewProvider {
////    static var previews: some View {
////        LogListView()
////    }
////}
