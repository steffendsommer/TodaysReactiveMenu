//
//  RACHelpers.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import ReactiveCocoa

public func ignoreError<T, E>(signalProducer: SignalProducer<T, E>) -> SignalProducer<T, NoError> {
    return signalProducer
        |> catch { _ in
            SignalProducer<T, NoError>.empty
        }
}

public func merge<T, E>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    return SignalProducer<SignalProducer<T, E>, E>(values: signals)
        |> flatten(.Merge)
}