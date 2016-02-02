//
//  PhoneService.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 29/10/15.
//  Copyright © 2015 steffendsommer. All rights reserved.
//

import WatchKit
import WatchConnectivity


class PhoneService: NSObject, WCSessionDelegate {

    private var menuStorage: MenuStorage?
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    private var sessionStarted = false


    // MARK: - Object Life Cycle

    init(menuStorage: MenuStorage) {
        self.menuStorage = menuStorage
    }


    // MARK: - Public Methods

    func startSession() {
        if (WCSession.isSupported()) {
            session?.delegate = self
            session?.activateSession()
            sessionStarted = true
        }
    }
    
    
    // Mark: - WCSessionDelegate
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        // Persist the menu (if storage class has been given).
        menuStorage?.saveMenu(applicationContext)
    }

}