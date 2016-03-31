//
//  InterfaceController.swift
//  TodaysReactiveMenuWatch Extension
//
//  Created by Steffen Damtoft Sommer on 27/09/15.
//  Copyright © 2015 steffendsommer. All rights reserved.
//

import WatchKit
import Foundation
import ReactiveCocoa
import Result


class InterfaceController: WKInterfaceController, MVVMViewResource {

    @IBOutlet var mainCourse: WKInterfaceLabel?
    @IBOutlet var sides: WKInterfaceLabel?
    var viewModel = TodaysMenuViewModel(menuAPI: TodaysMenuAPI())

    
    // MARK: - View Life Cycle
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.setupBindings()
    }
    
    
    // MARK: - RAC Bindings
    
    func setupBindings() {
        // Setup view helper bindings.
        self.setupViewBindings()
    
        // Setup custom bindings.
        self.viewModel.mainCourse.producer
            .observeOn(UIScheduler())
            .startWithNext { mainCourse in
                self.mainCourse?.setText(mainCourse)
            }
        
        combineLatest(self.viewModel.sides.producer, self.viewModel.shouldHideMenu.producer)
            .observeOn(UIScheduler())
            .startWithNext { sides, shouldHideMenu in
                self.sides?.setText(shouldHideMenu ? "" : sides)
            }
    }

}
