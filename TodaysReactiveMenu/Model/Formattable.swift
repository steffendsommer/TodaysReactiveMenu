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
            guard let instance: Self = Unbox(JSON) else {
                observer.sendFailed(FormattableError.DeserializationFailed)
                return
            }
            
            observer.sendNext(instance)
            observer.sendCompleted()
        }
    }

}