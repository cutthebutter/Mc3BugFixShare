//
//  MainTabView.swift
//  DetectiveLogWatch Watch App
//
//  Created by semini on 2023/07/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{
            LogRecordView()
                .tag(0)
            LogListView(viewModel: LogListViewModel())
                .tag(1)
        }

    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
