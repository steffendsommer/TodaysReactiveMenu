//
//  Menu.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import UIKit
import Unbox
import ReactiveCocoa


final class Menu: Unboxable, Archivable, Formattable {
   
    var link:       String!
    var servedAt:   NSDate!
    var mainCourse: String!
    var sides:      String!
    var cake:       Bool!
    
    
    // MARK: - Convenience methods -
    
    func isTodaysMenu() -> Bool {
        return NSCalendar.currentCalendar().isDateInToday(self.servedAt!)
    }
   
}


extension Menu {

    // Unbox extension.
    convenience init(unboxer: Unboxer) {
        self.init()
        self.link = unboxer.unbox("link")
        self.mainCourse = unboxer.unbox("main_course")
        self.sides = unboxer.unbox("sides")
        self.cake = unboxer.unbox("cake")
        self.servedAt = unboxer.unbox("serving_date", formatter: self.dateFormatter())
    }
    
    // Formattable extension
    func serialize() -> SignalProducer<[String: AnyObject], FormattableError> {
        return SignalProducer<[String: AnyObject], FormattableError>(value: [
            "link": self.link,
            "main_course": self.mainCourse,
            "sides": self.sides,
            "cake": self.cake,
            "serving_date": self.dateFormatter().stringFromDate(self.servedAt)
        ])
    }
    
    private func dateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }
    
}