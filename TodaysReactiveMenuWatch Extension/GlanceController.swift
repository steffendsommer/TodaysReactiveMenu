//
//  GlanceController.swift
//  TodaysReactiveMenuWatch Extension
//
//  Created by Steffen Damtoft Sommer on 27/09/15.
//  Copyright © 2015 steffendsommer. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {

    @IBOutlet var mainCourse: WKInterfaceLabel?
    
    private let menuNotReadyMsg = "The chef is working on it. Please come back later."
    private var menuStorage = MenuStorage()
    
    var menu: Menu? {
        didSet {
            self.mainCourse?.setText(menu?.mainCourse)
        }
    }
    

    // MARK: - View Life Cycle

    override func willActivate() {
        // Setup menu.
        fetchMenu()
    }
    
    
    // MARK: - Helpers
    
    func fetchMenu() {
        do {
            try self.menu = menuStorage.loadMenu()
        } catch {
            self.mainCourse?.setText(menuNotReadyMsg)
        }
    }

}
