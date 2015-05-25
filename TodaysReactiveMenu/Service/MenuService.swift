//
//  MenuService.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import ReactiveCocoa
import ObjectMapper

class MenuService {

    class func fetchTodaysMenu() -> SignalProducer<Menu?, NSError> {
    
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://unwire-menu.herokuapp.com/menus?limit=1")!)
    
        func parseJSON(signalProducer: SignalProducer<(NSData, NSURLResponse), NSError>) -> SignalProducer<Menu?, NSError> {
            return signalProducer
                |> map { (data, response) in
                    var parseError: NSError?
                    if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError)![0] as? NSDictionary {
                        if parseError == nil {
                            let menu = Mapper<Menu>().map(jsonDict)
                            return menu
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
            }
        }
    
        return session.rac_dataWithRequest(request)
            |> parseJSON
        
    }
    
}
