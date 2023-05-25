//
//  GroupView.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/5/22.
//

import SwiftUI

struct GroupView: View {
    @StateObject private var viewModel = GroupViewModel()
    @State private var selectedLabel: String?
    @State private var selectedItem: HomeItem?
    
    @State var hasLoaded = false
    
    var body: some View {
        NavigationView {
            SideBar(viewModel: viewModel, selectedFolder: $selectedLabel, selectedItem: $selectedItem)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if !hasLoaded {
                self.viewModel.load()
                self.hasLoaded = true
            }
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
