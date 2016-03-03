//
//  MVVMViewResourceiOS.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 03/03/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa


extension MVVMViewResource where Self: UIViewController {
    func setupViewBindings() {
        let active = NSNotificationCenter.defaultCenter().rac_notifications(UIApplicationDidBecomeActiveNotification)
            .map { _ in
                return true
            }
        
        let inactive = NSNotificationCenter.defaultCenter().rac_notifications(UIApplicationWillResignActiveNotification)
            .map { _ in
                false
            }
        
        self.viewModel.isActive <~ merge([active, inactive])
    }
}