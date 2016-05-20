//
//  Formattable.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 26/01/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation
import Unbox
import ReactiveCocoa


enum FormattableError: ErrorType {
    case SerializationFailed
    case DeserializationFailed
}


protocol Formattable {
    func serialize() -> SignalProducer<[String: AnyObject], FormattableError>
    static func deserializeFromJSON(JSON: [String: AnyObject]) -> SignalProducer<Self, FormattableError>
}


// Unbox extension.
extension Formattable where Self: Unboxable {

    static func deserializeFromJSON(JSON: [String: AnyObject]) -> SignalProducer<Self, FormattableError> {
        
        return SignalProducer { observer, disposable in
            
            do {
                let instance: Self = try Unbox(JSON)
                observer.sendNext(instance)
                observer.sendCompleted()
            } catch {
                observer.sendFailed(FormattableError.DeserializationFailed)
            }
            
        }
    }
}
