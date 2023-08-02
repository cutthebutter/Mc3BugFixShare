//
//  LogDetailView.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/25.
//

//import SwiftUI
//
//struct LogDetailView: View {
//    @State var fakeEachLog: FakeEachLog
//    
//    let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yy.MM.dd HH:mm"
//        return formatter
//    }()
//    
//    var body: some View {
//        VStack(alignment: .leading){
//            Text(fakeEachLog.title)
//                .font(.headline)
//            ScrollView{
//                VStack{
//                    HStack{
//                        Text(fakeEachLog.contents)
//                            .padding()
//                            
//                        Spacer()
//                    }
//                    .background(
//                        RoundedRectangle(cornerRadius: 5)
//                        //TODO: 하드코딩 색상 변경
//                            .foregroundColor(Color(red: 34 / 255, green: 34 / 255, blue: 35 / 255))
//                    )
//                }
//                
//                HStack{
//                    Spacer()
//                    Text(dateFormatter.string(from: fakeEachLog.date))
//                }
//                
//            }
//
//            
//            
//        }
//    }
//}
//
////struct LogDetailView_Previews: PreviewProvider {
////    static var previews: some View {
////        LogDetailView()
////    }
////}
