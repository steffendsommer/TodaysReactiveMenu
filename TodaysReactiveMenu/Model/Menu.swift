//
//  Menu.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import UIKit
import ObjectMapper


struct Menu: Mappable {
   
    var identifier: String?
    var link:       String?
    var servedAt:   NSDate?
    var mainCourse: String?
    var sides:      String?
    var cake:       Bool?
   
    
    // MARK: Object Life Cycle -
   
    static func newInstance(map: Map) -> Mappable? {
        return Menu()
    }

    
    // MARK: API Mapping -
    
    mutating func mapping(map: Map) {
        identifier  <- map["identifier"]
        link        <- map["link"]
        servedAt    <- (map["serving_date"], DateTransform())
        mainCourse  <- map["main_course"]
        sides       <- map["sides"]
        cake        <- map["cake"]
    }
    
    
    // MARK: Convenience methods
    
    func isTodaysMenu() -> Bool {
        return NSCalendar.currentCalendar().isDateInToday(self.servedAt!)
    }
   
}
