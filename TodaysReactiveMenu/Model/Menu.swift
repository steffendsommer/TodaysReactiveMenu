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


// MARK: - Helpers -

extension Menu {

    private func dateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }
    
    enum FetchMenuError: ErrorType {
        case UnknownError
        case APIError
        case CacheError
    }
    
    static func fetchTodaysMenuFromCacheOrRemote(menuAPI: RemoteResource) -> SignalProducer<Menu, FetchMenuError> {
    
        let cacheSharedIdentifier = "menu"
    
        // Download latest menu and deserialize into a menu instance.
        let fetchMenuFromRemote = menuAPI.latestMenu()
            .mapError { _ in
                return FetchMenuError.APIError
            }
            .flatMap(.Latest) { JSON in
                return Menu.deserializeFromJSON(JSON)
                    .mapError { error in
                        return FetchMenuError.APIError
                    }
            }
        
        let fetchMenuFromCache = Menu.loadUsingIdentifier(cacheSharedIdentifier)
            .mapError { _ in
                return FetchMenuError.CacheError
            }

        let fetchMenuFromCacheOrRemote = fetchMenuFromCache
            .flatMap(.Latest) { menu in
                return menu.isTodaysMenu() ? SignalProducer<Menu, FetchMenuError>(value: menu) : fetchMenuFromRemote
            }
            .flatMapError { error in
                return (error == FetchMenuError.CacheError) ? fetchMenuFromRemote : SignalProducer<Menu, FetchMenuError>(error: error)
            }

        return fetchMenuFromCacheOrRemote
            .flatMap(.Latest) { menu in
                return menu.saveUsingIdentifier(cacheSharedIdentifier)
                    .map { _ in
                        return menu
                    }
                    .flatMapError { _ in
                        return SignalProducer<Menu, FetchMenuError>(value: menu)
                    }
            }
    }
    
}


// MARK: - Unboxable extension -

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
    
}


// MARK: - Formattable extension -

extension Menu {

    func serialize() -> SignalProducer<[String: AnyObject], FormattableError> {
        return SignalProducer<[String: AnyObject], FormattableError>(value: [
            "link": self.link,
            "main_course": self.mainCourse,
            "sides": self.sides,
            "cake": self.cake,
            "serving_date": self.dateFormatter().stringFromDate(self.servedAt)
        ])
    }
    
}

