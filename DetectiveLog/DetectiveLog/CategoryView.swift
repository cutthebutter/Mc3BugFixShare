//
//  CategoryView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/20.
//

import SwiftUI
import CloudKit

struct CategoryView: View {
    
//    @State var recordId: [CKRecord.ID] = []
    @State var recordId: [UUID] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("질곡동 사건 기록")
                    .padding()
                Rectangle()
                    .foregroundColor(.black)
                    .frame(height: 0.5)
                    .frame(maxWidth: .infinity)

                    .padding(.bottom, 25)
                HStack {
                    categoryButton
                }
                .padding([.leading, .trailing], 24)
                Spacer()
            }
            .navigationTitle("카테고리 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(red: 116 / 255,
                                                   green: 116 / 255,
                                                   blue: 128 / 255))
                    }

                }
            }
        }
        
    }
    
    var categoryButton: some View {
        Group {
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .buttonText("진행 중인\n사건")
            }
            
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .buttonText("완결된\n사건")
            }
            
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .buttonText("미완결된\n사건")
            }
        }
    }
    
}

extension RoundedRectangle {
    func buttonText(_ text: String) -> some View {
        self
            .foregroundColor(Color(red: 222/255, green: 222/255, blue: 222/255))
            .frame(height: 83)
            .overlay {
                Text(text)
                    .foregroundColor(.black)
            }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}


