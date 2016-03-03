//
//  MVVMViewResourceWatchOS.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 03/03/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation
import WatchKit
import ReactiveCocoa


extension MVVMViewResource where Self: WKInterfaceController {
    func setupViewBindings() {
        let activeSelectorString = "willActivate"
        let inactiveSelectorString = "didDeactivate"
    
        // Handle view being active/inactive
        let active = self.rac_signalForSelector(Selector(activeSelectorString))
            .toSignalProducer()
            .ignoreError()
            .map { _ in
                return true
            }
        
        let inactive = self.rac_signalForSelector(Selector(inactiveSelectorString))
            .toSignalProducer()
            .ignoreError()
            .map { _ in
                false
            }
        
        self.viewModel.isActive <~ merge([active, inactive])
    }
}