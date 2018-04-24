//
//  NetworkReachability.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/24/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import Foundation
import ReachabilitySwift

protocol NetworkStatusListener: class {
    func networkStatusDidChange(status: Reachability.NetworkStatus)
}

class NetworkReachability: NSObject {
    
    static let shared = NetworkReachability()
    var isNetworkAvailable: Bool {
        return reachabilityStatus != .notReachable
    }
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    let reachability = Reachability()!
    var listeners = [NetworkStatusListener]()
    
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            NSLog("Network became unreachable")
        case .reachableViaWiFi:
            NSLog("Network reachable through WiFi")
        case .reachableViaWWAN:
            NSLog("Network reachable through Cellular Data")
        }
        
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.currentReachabilityStatus)
        }
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Couldn't start reachability notifier")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    func addListener(listener: NetworkStatusListener) {
        listeners.append(listener)
    }
    
    func removeListener(listener: NetworkStatusListener) {
        listeners = listeners.filter({ $0 !== listener })
    }
    
}
