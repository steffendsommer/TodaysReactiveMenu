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
