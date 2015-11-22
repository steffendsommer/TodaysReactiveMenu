//
//  WatchService.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 30/09/15.
//  Copyright © 2015 steffendsommer. All rights reserved.
//

import Foundation
import WatchConnectivity
import ObjectMapper

class WatchService: NSObject, WCSessionDelegate {

    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    private var sessionStarted = false

    func startSession() {
        if (WCSession.isSupported()) {
            session?.delegate = self
            session?.activateSession()
            sessionStarted = true
        }
    }

    func sendMenu(menu: Menu) {
    
        // Make sure that the session is up and running.
        if (sessionStarted) {
            do {
                try session?.updateApplicationContext(Mapper().toJSON(menu))
            } catch let error {
                print("Failed to send menu to Watch: \(error)")
            }
        }
    
    }

}