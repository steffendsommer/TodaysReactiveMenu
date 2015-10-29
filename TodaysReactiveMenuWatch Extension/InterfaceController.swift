//
//  InterfaceController.swift
//  TodaysReactiveMenuWatch Extension
//
//  Created by Steffen Damtoft Sommer on 27/09/15.
//  Copyright © 2015 steffendsommer. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import ObjectMapper


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var mainCourse: WKInterfaceLabel?
    @IBOutlet var sides: WKInterfaceLabel?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func willActivate() {
        super.willActivate()
    }
    
    
    // MARK: - Helpers
    
    func updateMenu() {
     if let menu = MenuHelper().loadMenu() {
        self.mainCourse?.setText(menu.mainCourse)
        self.sides?.setText(menu.sides)
     }
    }
    
    
    // Mark: - WCSessionDelegate
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
        if let menu = Mapper<Menu>().map(applicationContext) {
            let helper = MenuHelper()
            helper.saveMenu(menu)
            self.updateMenu()
        }
    }

}
