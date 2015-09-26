//
//  MenuService.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import ReactiveCocoa
import ObjectMapper
import Result


struct MenuService {

    func fetchTodaysMenu() -> SignalProducer<Menu?, NSError> {
      
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: NSURL(string: "https://unwire-menu.herokuapp.com/menus?limit=1")!)
      
        return session.rac_dataWithRequest(request)
            .map { data, response in
                do {
                    let json = try (NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [NSDictionary])?.first
                    return Mapper<Menu>().map(json)
                } catch {
                    print("Failed to parse menu")
                    return nil
                }
            }
            
    }

    func submitPushToken(token: NSString) -> Void {

        // Fire and forget.
        do {
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: NSURL(string: "https://unwire-menu.herokuapp.com/devices")!)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.HTTPMethod = "POST"
            let body = try (NSJSONSerialization.dataWithJSONObject(["token" : token], options: NSJSONWritingOptions(rawValue: 0)))
            request.HTTPBody = body
            let task = session.dataTaskWithRequest(request)
            task.resume()
        } catch {
            print("Failed to submit push token")
        }

    }

}