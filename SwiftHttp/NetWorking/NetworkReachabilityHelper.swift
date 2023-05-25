//
//  NetworkReachabilityHelper.swift
//  SwiftHttp
//
//  Created by 吴书敏 on 2023/4/28.
//

import Foundation
import Combine
import Alamofire

final class NetworkReachabilityHelper {
    static let shared = NetworkReachabilityHelper()
    
    private enum Constants {
        static let host = kPing
    }
    
    var reachability = NetworkReachabilityManager(host: Constants.host)
    
    let networkStatus = PassthroughSubject<NetworkReachabilityManager.NetworkReachabilityStatus, Error>()
    
    var isReachableOnCellular: Bool {
        get {
            return reachability?.isReachableOnCellular ?? false
        }
    }
    
    var isReachableOnEthernetOrWiFi: Bool {
        get {
            return reachability?.isReachableOnEthernetOrWiFi ?? false
        }
    }
    
    var isReachable: Bool {
        get {
            return reachability?.isReachable ?? false
        }
    }
        
    func startListening() {
        reachability?.startListening(onUpdatePerforming: { [weak self] status in
            self?.networkStatus.send(status)
        })
    }
    
    func stopListening() {
        reachability?.stopListening()
    }
    
    deinit {
        stopListening()
    }
    
}
