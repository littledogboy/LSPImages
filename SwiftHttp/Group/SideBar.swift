//
//  SideBar.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/5/24.
//

import SwiftUI

struct SideBar: View {
    @ObservedObject var viewModel: GroupViewModel
    @Binding var selectedFolder: String?
    @Binding var selectedItem: HomeItem?
    
    var body: some View {
        List {
            if let sections = viewModel.sections {
                ForEach(sections) { section in
                    NavigationLink(destination: FolderView(title: section.title, items: section.items, selectedItem: $selectedItem),
                                   tag: section.title,
                                   selection: $selectedFolder) {
                        Text(section.title)
                            .font(.headline)
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationBarTitle("精品全集", displayMode: .inline)
    }
}
