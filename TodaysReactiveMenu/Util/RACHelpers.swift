//
//  RACHelpers.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import Foundation
import ReactiveCocoa


public func ignoreNil<T: AnyObject, E: Any>(signalProducer: SignalProducer<T?, E>) -> SignalProducer<T?, E> {
	return signalProducer
        |> filter { value in
            value != nil
        }
}

public func ignoreError<T: Any, E: ErrorType>(signalProducer: SignalProducer<T, E>) -> SignalProducer<T, NoError> {
    return signalProducer
        |> catch { _ in
            SignalProducer<T, NoError>.empty
        }
}

public func merge<T, E: ErrorType>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    return SignalProducer<SignalProducer<T, E>, E>(values: signals)
        |> flatten(FlattenStrategy.Merge)
}