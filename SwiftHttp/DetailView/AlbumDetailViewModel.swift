//
//  AlbumDetailViewModel.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/3/14.
//

import SwiftUI

class AlbumDetailViewModel: ObservableObject {
    @Published private(set) var albumDetail: AlbumDetail = AlbumDetail()
    @Published var isLoading = false
    var tapUrlString: String?

    func loadData(with href: String?) {
        self.isLoading = true

        guard href != "" else {
            dPrint(item: "链接为空")
            return
        }
        
        let path = "detail"
        var urlComp = URLComponents(string: serverDomain + path)
        let urlQueryItems = [URLQueryItem(name: "href", value: href)]
        urlComp?.queryItems = urlQueryItems
        let url = urlComp?.url
        let request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        
        let dask = URLSession.shared.dataTask(with: request) { data, response, error in
            self.isLoading = false
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let modelObject = try decoder.decode(AlbumDetail.self, from: data)
                    self.albumDetail = modelObject
//                    DispatchQueue.main.async {
////                        dPrint(item: data.prettyPrintedJSONString!)
//                    }
                } catch {
                    dPrint(item: "数据解析出错, \(error.localizedDescription)")
                }
            } else if let error = error {
                dPrint(item: "网络请求出错: \(error.localizedDescription)")
            }
        }
    
        dask.resume()
    }
}
