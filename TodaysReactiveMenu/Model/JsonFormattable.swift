//
//  JsonFormattable.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 26/01/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation
import ReactiveCocoa


typealias JsonDictionary = [String: AnyObject]

enum JsonFormattableError: ErrorType {
    case SerializationFailed
    case DeserializationFailed
}

protocol JsonFormattable {
    init?(dictionary: JsonDictionary)
    static func fromJson(json: JsonDictionary) -> SignalProducer<Self, JsonFormattableError>
    func toJson() -> SignalProducer<JsonDictionary, JsonFormattableError>
}


// Unbox extension.
//extension JsonFormattable where Self: Unboxable {
//
//    static func deserializeFromJSON(JSON: [String: AnyObject]) -> SignalProducer<Self, FormattableError> {
//        
//        return SignalProducer { observer, disposable in
//            
//            do {
//                let instance: Self = try Unbox(JSON)
//                observer.sendNext(instance)
//                observer.sendCompleted()
//            } catch {
//                observer.sendFailed(FormattableError.DeserializationFailed)
//            }
//            
//        }
//    }
//}
