//
//  GroupViewModel.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/5/23.
//

import Foundation
import SwiftUI

class GroupViewModel: ObservableObject, LoadableObject {
    @Published var state: LoadingState<[MenuSection]> = .idle
    
    func load() {
        self.state = .loading
        Task {
            do {
                let url = URL(string: kMenu)
                let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
                let (data, response) =  try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    self.state = .failed(URLError(.badServerResponse))
                    return
                }
                
                let menuData = try JSONDecoder().decode(MenuData.self, from: data)
                self.state = .loaded(menuData.sections)
            } catch  {
                self.state = .failed(error)
                dPrint(item: error)
            }
        }
    }
}
