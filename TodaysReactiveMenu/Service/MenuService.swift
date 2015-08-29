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


func fetchTodaysMenu() -> SignalProducer<Menu?, NSError> {
  
    let session = NSURLSession.sharedSession()
    let request = NSURLRequest(URL: NSURL(string: "https://unwire-menu.herokuapp.com/menus?limit=1")!)
  
    return session.rac_dataWithRequest(request)
        |> map { data, response in
            let json = try { (NSJSONSerialization.JSONObjectWithData(data, options: nil, error: $0) as? [NSDictionary])?.first }
            return Mapper<Menu>().map(json.value)
    }
}

func submitPushToken(token: NSString) -> Void {

    // Fire and forget.
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "https://unwire-menu.herokuapp.com/devices")!)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.HTTPMethod = "POST"
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(["token" : token], options: nil, error: nil)

    let task = session.dataTaskWithRequest(request)
    task.resume()

}