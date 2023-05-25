//
//  FolderView.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/5/24.
//

import SwiftUI

struct FolderView: View {
    let title: String
    let items: [HomeItem]
    @Binding var selectedItem: HomeItem?
    
    var body: some View {
        List{
            ForEach(items) { item in
                NavigationLink(destination: HomeView(menuItem: item),
                               tag: item,
                               selection: $selectedItem) {
                    Text(item.title ?? "")
                }
            }
        }
        .navigationTitle(title)
    }
}
