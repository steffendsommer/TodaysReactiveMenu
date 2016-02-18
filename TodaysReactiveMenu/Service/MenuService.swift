//
//  MenuService.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

//import ReactiveCocoa
//import Alamofire
//import Unbox


//#if DEBUG
//    private let env = "sandbox"
//#else
//    private let env = "production"
//#endif
//
//private let latestMenuUrl   = "https://todays-menu.herokuapp.com/api/v1/menus?limit=1"
//private let submitTokenUrl  = "https://todays-menu.herokuapp.com/api/v1/devices"
//
//private let tokenKey        = "token"
//private let typeKey         = "type"
//private let typeIosValue    = "ios"
//private let environmentKey  = "environment"
//
//
//struct MenuService {
//
//    private var auth_token: String?
//    
//    func fetchTodaysMenu() -> SignalProducer<Menu?, NSError> {
//    
//        let request = Alamofire.request(.GET, latestMenuUrl, parameters: nil)
//        return SignalProducer { observer, disposable in
//            
//            request.responseJSON { response in
//                 if let JSON = response.result.value as? [[String: AnyObject]] {
//                    let menu: Menu? = Unbox((JSON.first)!)
//                    print("menu downloaded")
//                    observer.sendNext(menu)
//                    observer.sendCompleted()
//                 } else {
//                    observer.sendFailed(response.result.error!)
//                 }
//            }
//            
//            disposable.addDisposable(request.cancel)
//        }
//    
//    }
//
//    func submitPushToken(token: NSString) -> SignalProducer<AnyObject, NSError> {
//    
//        let parameters = [tokenKey : token, typeKey : typeIosValue, environmentKey : env]
//        let request = Alamofire.request(.POST, submitTokenUrl, parameters: parameters)
//        return SignalProducer { observer, disposable in
//        
//            request.responseJSON { response in
//                if let error = response.result.error {
//                    observer.sendFailed(error)
//                } else {
//                    observer.sendCompleted()
//                }
//            }
//            
//            disposable.addDisposable(request.cancel)
//        }
//    }
//
//}