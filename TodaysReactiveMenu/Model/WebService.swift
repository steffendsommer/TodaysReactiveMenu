//
//  WebService.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/08/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation


protocol WebServiceType {
    associatedtype V: WebResource
    func load<V>(resource: WebResource<V>, completion: (V?) -> ())
}

final class WebService: WebServiceType {
    func load<V>(resource: Resource<V>, completion: (V?) -> ()) {
        NSURLSession.sharedSession().dataTaskWithURL(resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
        }.resume()
    }
}
