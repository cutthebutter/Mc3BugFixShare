//
//  MainView.swift
//  DetectiveLog
//
//  Created by 한지석 on 2023/07/19.
//

import SwiftUI

struct MainView: View {
    @State var selection = "진행 중"
    
    var body: some View {
        VStack {
            CategoryPickerView(selection: $selection)
            Text(selection)
        }
    }
}

struct CategoryPickerView: View {
    @Binding var selection: String
    var category = ["진행 중", "완결", "미완결"]
    
    var body: some View {
        Picker("Hi", selection: $selection) {
            ForEach(category, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
