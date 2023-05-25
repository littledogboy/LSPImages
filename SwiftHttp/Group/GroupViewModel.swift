//
//  GroupViewModel.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/5/23.
//

import Foundation
import SwiftUI

class GroupViewModel: ObservableObject {
    @Published var sections: [MenuSection]?
    
    func load() {
        Task {
            
            do {
                let url = URL(string: kMenu)
                let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
                let (data, response) =  try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return
                }
                
                let menuData = try JSONDecoder().decode(MenuData.self, from: data)
                self.sections = menuData.sections
            } catch  {
                dPrint(item: error)
            }
        }
    }
}
