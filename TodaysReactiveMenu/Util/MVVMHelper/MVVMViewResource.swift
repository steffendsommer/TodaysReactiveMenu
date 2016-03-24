//
//  ViewResource.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 02/03/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation
import UIKit
import WatchKit
import ReactiveCocoa


protocol MVVMViewResource {
    associatedtype VM: MVVMViewModelResource
    var viewModel: VM { get }
    func setupBindings()
}