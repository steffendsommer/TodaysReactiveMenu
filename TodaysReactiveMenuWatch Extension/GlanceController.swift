//
//  GlanceController.swift
//  TodaysReactiveMenuWatch Extension
//
//  Created by Steffen Damtoft Sommer on 27/09/15.
//  Copyright © 2015 steffendsommer. All rights reserved.
//

import WatchKit
import Foundation
import ReactiveCocoa


class GlanceController: WKInterfaceController, MVVMViewResource {

    @IBOutlet var mainCourse: WKInterfaceLabel?
    
    var viewModel = TodaysMenuViewModel(menuAPI: TodaysMenuAPI())
    

    // MARK: - View Life Cycle

    override init() {
        super.init()
        
        self.setupBindings()
    }
    
    
    // MARK: - RAC Bindings
    
    func setupBindings() {
    
        self.setupViewBindings()
    
        self.viewModel.mainCourse.producer
            .observeOn(UIScheduler())
            .startWithNext { mainCourse in
                self.mainCourse?.setText(mainCourse)
        }
    }
}
