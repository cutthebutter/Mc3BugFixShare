//
//  DetailLogView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct DetailLogView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                title
                if viewModel.combineLogData == [] {
                    VStack(alignment: .center) {
                        ProgressView()
                    }
                }
                combineLogCell
            }

            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("testBtn") {
                        // 테스트용 입니다.
                    }
                    Button {
                        if let log = viewModel.log {
                            viewModel.createLogMemo(log: log, memo: "키오")
                        }
                    } label: {
                        Text("단서추가")
                            .font(.custom("AppleSDGothicNeo-SemiBold", size: 20))
                            .foregroundColor(.black)
                            
                    }

                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                if let log = viewModel.log {
                    Task {
                        await viewModel.fetchLogData(log: log)
                    }
                } else {
                    viewModel.createLog()
                }
            }
        }
    }
    
    var title: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(.white)
                .frame(height: 66)
                .frame(maxWidth: .infinity)
            
            if let log = viewModel.log {
                Text(log.title)
                    .font(.custom("AppleSDGothicNeo-Bold", size: 22))
                    .padding(.top, 16)
                    .padding(.leading, 20)
            }
        }
        
    }
    
    var combineLogCell: some View {
        ScrollViewReader { list in
            List {
                ForEach(viewModel.combineLogData.indices, id: \.self) { dataIndex in
                    DateCell(combineLogData: viewModel.combineLogData[dataIndex])
                        .listRowInsets(EdgeInsets())
                        .listRowSeparatorTint(.white)
                    ForEach(viewModel.combineLogData[dataIndex].logMemo.indices, id: \.self) { memoIndex in
                        memoCell(logMemo: $viewModel.combineLogData[dataIndex].logMemo[memoIndex])
                            .id(viewModel.combineLogData[dataIndex].logMemo[memoIndex].id)
                            .onTapGesture {
                                viewModel.updateTextField = viewModel.combineLogData[dataIndex].logMemo[memoIndex].id
                            }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparatorTint(.white)
                }
            }
            
            .listStyle(.plain)
            .onChange(of: viewModel.lastIndex) { _ in
                withAnimation {
                    list.scrollTo(viewModel.lastIndex)
                }
            }
//            .onChange(of: viewModel.updateTextField) { _ in
//                print("@Log UpdateTextField")
//                list.scrollTo(viewModel.updateTextField)
//            }
        }
    }

    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: date)
    }
    
}

//struct HideRowSeparatorModifier: ViewModifier {
//
//    static let defaultListRowHeight: CGFloat = 44
//
//    var insets: EdgeInsets
//    var background: Color
//
//    init(insets: EdgeInsets, background: Color) {
//        self.insets = insets
//
//        var alpha: CGFloat = 0
//        UIColor(background).getWhite(nil, alpha: &alpha)
//        assert(alpha == 1, "Setting background to a non-opaque color will result in separators remaining visible.")
//        self.background = background
//    }
//
//    func body(content: Content) -> some View {
//        content
//            .padding(insets)
//            .frame(
//            minWidth: 0, maxWidth: .infinity,
//            minHeight: Self.defaultListRowHeight,
//            alignment: .leading
//        )
//            .listRowInsets(EdgeInsets())
//            .background(background)
//    }
//}
//
//extension EdgeInsets {
//
//    static let defaultListRowInsets = Self(top: 0, leading: 16, bottom: 0, trailing: 16)
//}
//
//extension View {
//
//    func hideRowSeparator(
//        insets: EdgeInsets = .defaultListRowInsets,
//        background: Color = .white
//    ) -> some View {
//        modifier(HideRowSeparatorModifier(
//            insets: insets,
//            background: background
//            ))
//    }
//}

//struct DetailLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailLogView()
//    }
//}
