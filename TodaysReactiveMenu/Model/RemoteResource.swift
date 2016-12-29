//
//  RemoteResource.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 27/01/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation
import ReactiveCocoa

#if DEBUG
    private let env = "sandbox"
#else
    private let env = "production"
#endif


protocol WebResourceType {
    associatedtype T: Any
    var url: NSURL { get }
    var parse: (NSData -> T?)? { get }
}

struct WebResource<T>: WebResourceType {
    let url: NSURL
    let parse: (NSData -> T?)?
}

extension WebResource {
    init(url: NSURL, parseJSON: AnyObject -> T?) {
        self.url = url
        self.parse = { data in
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}





enum APIError: ErrorType {
    case RequestFailed
    case SerializationFailed
}


protocol RemoteResource {
    func latestMenu() -> SignalProducer<[String: AnyObject], APIError>
    func submitPushToken(token: String) -> SignalProducer<Void, APIError>
}


struct TodaysMenuAPI: RemoteResource {

    let baseUrl = "https://todays-menu.herokuapp.com/api/"

    func latestMenu() -> SignalProducer<[String: AnyObject], APIError> {
        let latestMenuUrl   = "\(baseUrl)v1/menus?limit=1"
        let request = Alamofire.request(.GET, latestMenuUrl, parameters: nil)
       
         return SignalProducer { observer, disposable in
            request.responseJSON { response in
            
                switch response.result {
                    case .Success(let data):
                        guard let JSON = data as? [[String: AnyObject]] else {
                            observer.sendFailed(APIError.SerializationFailed)
                            return
                        }
                    
                        observer.sendNext(JSON.first!)
                        observer.sendCompleted()
                    
                    case .Failure(_):
                        observer.sendFailed(APIError.RequestFailed)
                }
            }
            
            disposable.addDisposable(request.cancel)
        }
    }
    
    func submitPushToken(token: String) -> SignalProducer<Void, APIError> {
        let submitTokenUrl  = "\(baseUrl)v1/devices"
        let tokenKey        = "token"
        let typeKey         = "type"
        let typeIosValue    = "ios"
        let environmentKey  = "environment"
        let parameters = [tokenKey : token, typeKey : typeIosValue, environmentKey : env]
        let request = Alamofire.request(.POST, submitTokenUrl, parameters: parameters)
        
        return SignalProducer { observer, disposable in
            request.responseJSON { response in
            
                switch response.result {
                    case .Success(_):
                        observer.sendCompleted()
                    
                    case .Failure(_):
                        observer.sendFailed(APIError.RequestFailed)
                }
            }
            
            disposable.addDisposable(request.cancel)
        }
    }
}
