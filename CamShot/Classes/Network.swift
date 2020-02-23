//
//  Network.swift
//  WellControl
//
//  Created by IshwarSingh on 23/02/2020.
//  Copyright (c) 2020 IshwarSingh. All rights reserved.
//

import UIKit
import FirebaseCore

/// Internet status module
class Network {
    
    /// Can't init is singleton
    private init() {
        initialize()
    }

    /// static shared instance
    static var shared = Network()
    
    
    private var syncProtocol = SyncNetwork()
    
    /// Boolean to check internet connection
    var isInternetAvailable: Bool = false
    
    /// Reachability object
    private var reachability: Reachability?
    
    private func initialize() {
        FirebaseApp.configure()
        setupReachability("google.com")
        startNotifier()
    }
    
    deinit {
        stopNotifier()
    }
    
    /// Setup and check internet for host name
    private func setupReachability(_ hostName: String?) {
        debugPrint("--- set up with host name: \((hostName != nil ? hostName! : "No host name"))")
        
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        self.reachability = reachability
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.isInternetAvailable = true
                
                debugPrint("Internet Status: \(( self.isInternetAvailable))")
                self.syncProtocol.syncCapturedImg()
            }
        }
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.isInternetAvailable = false
                debugPrint("Internet Status: \(( self.isInternetAvailable))")
            }
        }
    }
    
    /// MARK: - Notifier methods
    private func startNotifier() {
        debugPrint("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            debugPrint("Unable to start\nnotifier")
            return
        }
    }
    
    /// MARK: - Notifier methods
    private func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
}

