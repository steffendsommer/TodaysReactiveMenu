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

    func startSession() {
        if (WCSession.isSupported()) {
            session?.delegate = self
            session?.activateSession()
        }
    }

    func sendMenu(menu: Menu) {
    
        if (WCSession.isSupported()) {
            
            if let data = Mapper().toJSONString(menu, prettyPrint: true)!.dataUsingEncoding(NSUTF8StringEncoding) {
                do {
                    let menuDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                    try session?.updateApplicationContext(menuDictionary!)
                } catch {
                    print("Something went wrong")
                }
            }

        }
    
    }

}