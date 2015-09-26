//
//  RACHelpers.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import ReactiveCocoa


extension SignalProducer where T: OptionalType {
	public func ignoreError() -> SignalProducer<T, NoError> {
		return flatMapError { _ in
            SignalProducer<T, NoError>.empty
        }
	}
}

public func merge<T, E>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    return SignalProducer<SignalProducer<T, E>, E>(values: signals).flatten(.Merge)
}