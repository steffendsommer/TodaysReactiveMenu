//
//  MVVMViewModelResource.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 02/03/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation
import ReactiveCocoa


protocol MVVMViewModelResource {
    var isActive: MutableProperty<Bool> { get }
}