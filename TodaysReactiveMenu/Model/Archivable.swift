//
//  Archivable.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 26/01/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation
import ReactiveCocoa


enum ArchivableError: ErrorType {
    case ValueNotFound
    case SaveFailed
    case LoadFailed
}


protocol Archivable {
    func saveUsingIdentifier(identifier: String) -> SignalProducer<Void, ArchivableError>
    static func loadUsingIdentifier(identifier: String) -> SignalProducer<Self, ArchivableError>
}

// Extension for NSUserDefaults.
extension Archivable where Self: Formattable {

    func saveUsingIdentifier(identifier: String) -> SignalProducer<Void, ArchivableError> {
    
        return self.serialize()
            .on(next: { value in
                NSUserDefaults.standardUserDefaults().setObject(value, forKey: identifier)
            })
            .mapError { error in
                return ArchivableError.SaveFailed
            }
            .map { _ in
                return Void()
            }
        
    }
    
    static func loadUsingIdentifier(identifier: String) -> SignalProducer<Self, ArchivableError> {
    
        return SignalProducer { observer, disposable in
            guard let data = NSUserDefaults.standardUserDefaults().objectForKey(identifier) as? [String: AnyObject] else {
                observer.sendFailed(ArchivableError.ValueNotFound)
                return
            }
            
            observer.sendNext(data)
            observer.sendCompleted()
        }
        .flatMap(.Latest) { value in
            return Self.deserializeFromJSON(value)
                .mapError { error in
                    return ArchivableError.LoadFailed
                }
        }
        
    }

}