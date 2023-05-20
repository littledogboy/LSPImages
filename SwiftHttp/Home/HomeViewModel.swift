//
//  HomeViewModel.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/2/26.
//

import SwiftUI
import Combine

class HomeViewModel:LoadableObject, ObservableObject {
    @Published private(set) var state = LoadingState<[HomeItem]>.idle
    var currentPage = 1
    var cancellable: AnyCancellable?

    func load() {
        
        self.state = .loading
        
        Task {
            var isServerON = false
            
            dPrint(item: "检查服务器健康")
            do {
                let (_, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: ping)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 3))
                if let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 {
                    isServerON = true
                }
            } catch {
                dPrint(item: error)
            }
            dPrint(item: "检查服务器检查完毕")

            dPrint(item: "服务器是否在线：\(isServerON), 进行下一步请求")
            let url = URL(string: serverDomain)?.appendingPathComponent("home")
            let request = URLRequest(url: url!, cachePolicy: isServerON ? .useProtocolCachePolicy : .returnCacheDataElseLoad, timeoutInterval: 10)
            do {
                let (data, response) = try await URLSession.shared.data(for:request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    self.state = .failed(URLError(.badServerResponse))
                    return
                }
                
                let decodeData = try JSONDecoder().decode(HomeData.self, from: data)
                self.state = .loaded(decodeData.recommends)
                self.currentPage = 1
            } catch {
                self.state = .failed(error)
            }
        }
        
         /*
        let url: URL? = URL(string: serverDomain)?.appendingPathComponent("home")
        let request: URLRequest = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        let dask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.state = .failed(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.state = .failed(URLError(.badServerResponse))
                return
            }
            
            if let data = data {
                do {
                    let decodeData = try JSONDecoder().decode(HomeData.self, from: data)
                    self.state = .loaded(decodeData.recommends)
                } catch {
                    self.state = .failed(error)
                }
            }
        }
        dask.resume()
          */
    }
    
    func loadMore() {
        let nextPage = currentPage + 1
        
        let path = "home"
        var urlComp = URLComponents(string: serverDomain + path)
        let urlQueryItems = [URLQueryItem(name: "page", value: String(nextPage))]
        urlComp?.queryItems = urlQueryItems
        let url = urlComp?.url
        let request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        
        cancellable = URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap({ (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 else {
                                throw URLError(.badServerResponse)
                                
                            }
                return data
            })
            .decode(type: HomeData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: {
                print ("Received completion: \($0).")
            }, receiveValue: { homeData in
                switch self.state {
                case .loaded(let items):
                    let newArray: [HomeItem] = items + homeData.recommends
                    self.state = .loaded(newArray)
                    self.currentPage += 1
                default:
                    print("")
                }
            })
    }
    
    func reload() async {
        self.state = .loading
        let url = URL(string: serverDomain)?.appendingPathComponent("home")
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        do {
            let (data, _) = try await URLSession.shared.data(for:request)
            let decodeData = try JSONDecoder().decode(HomeData.self, from: data)
            self.state = .loaded(decodeData.recommends)
            self.currentPage = 1
        } catch {
            self.state = .failed(error)
        }
    }
}

