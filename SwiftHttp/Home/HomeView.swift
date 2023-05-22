//
//  HomeView.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/2/26.
//

import SwiftUI
import SwiftUIPullToRefresh


struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    
    var body: some View {
        AsyncContentView(source: vm) { recommends in
            NavigationView {
                
                GeometryReader { geom in
                    
                    let radio = 402.0 / 268.0
                    let spacing = 10.0
                    let hozionPadding = 5.0
                    let width = (geom.size.width - spacing - hozionPadding * 2) / 2.0
                    let height = width * radio
                    let columns = [GridItem(.fixed(width)), GridItem(.fixed(width))]
                    
                    
                    RefreshableScrollView(action: {
                        await self.vm.reload()
                     }, progress: { state in
                         RefreshActivityIndicator(isAnimating: state == .loading) {
                             $0.hidesWhenStopped = false
                         }
                     }) {
                         LazyVGrid(columns: columns, spacing: 8) {
                             ForEach(recommends) { item in
                                 NavigationLink {
                                     AlbumDetailView(homeItem: item)
                                 } label: {
                                     HomeCell(item: item)
                                         .frame(width: width, height: height)
                                         .cornerRadius(4)
                                         .clipped()
                                         .onAppear() {
                                             if item == recommends.last {
                                                 self.vm.loadMore()
                                             }
                                         }
                                 }
                             }
                         }
                     }
                    .padding(EdgeInsets(top: 8,
                                        leading: 0,
                                        bottom: 0,
                                        trailing: 0))
                    .background(Color(hex: "#F0F0F0"))
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
