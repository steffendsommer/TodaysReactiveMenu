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
    
        // Handle view being active/inactive
        let active = self.rac_signalForSelector(#selector(willActivate))
            .toSignalProducer()
            .ignoreError()
            .map { _ in
                return true
            }
            .on(next: { _ in
                print("active")
            })
        
        let inactive = self.rac_signalForSelector(#selector(didDeactivate))
            .toSignalProducer()
            .ignoreError()
            .map { _ in
                false
            }
            .on(next: { _ in
                print("inactive")
            })
        
        self.viewModel.isActive <~ merge([active, inactive])
    }
}