//
//  MenuHelper.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 28/10/15.
//  Copyright © 2015 steffendsommer. All rights reserved.
//

import WatchKit
import ObjectMapper


struct MenuHelper {

    private let storeKey = "latest_menu"

    func saveMenu(menu: Menu) {
        NSUserDefaults.standardUserDefaults().setObject(menu, forKey: storeKey)
    }
    
    func loadMenu() -> Menu? {
        return NSUserDefaults.standardUserDefaults().objectForKey(storeKey) as? Menu
    }

}
