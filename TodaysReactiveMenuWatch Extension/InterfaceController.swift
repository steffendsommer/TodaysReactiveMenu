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


class InterfaceController: WKInterfaceController {

    @IBOutlet var mainCourse: WKInterfaceLabel?
    @IBOutlet var sides: WKInterfaceLabel?
    
    private let menu = MutableProperty<Menu?>(nil)
    private let menuNotReadyMsg = "The chef is working on it. Please come back later."
    private let fetchMenuErrorMsg   = "Something went wrong in the kitchen. Please come back later."
//    private var menuStorage = MenuStorage()
//    private let menuService = MenuService()
    
//    private let viewModel = TodaysMenuViewModel(menuService: MenuService())
    
//    var menu: Menu? {
//        didSet {
//            self.mainCourse?.setText(menu?.mainCourse)
//            self.sides?.setText(menu?.sides)
//        }
//    }

    
    // MARK: - View Life Cycle
    
    override init() {
        super.init()
        
        self.setupBindings()
    }
    
//    override func willActivate() {
//        // Setup menu.
//        fetchMenu()
//    }
    
    
    // MARK: - RAC Bindings
    
    func setupBindings() {
    
//        self.menu <~ self.rac_signalForSelector(Selector(willActivate()))
//            .toSignalProducer()
//            .flatMap(.Latest) { _ in
//                return self.menuService.fetchTodaysMenu()
//            }
    
        // The idea:
        // 1) get menu from cache (error if no found)
        // 2) flatMapError into fetching it remotely (error if no found)
        // 3) mapError into something like "menu not ready"
    
    
//        self.menu.producer
//            .ignoreNil()
//            .observeOn(UIScheduler())
//            .startWithNext { menu in
//                if menu.isTodaysMenu() {
//                    self.mainCourse?.setText(menu.mainCourse)
//                    self.sides?.setText(menu.sides)
//                } else {
//                    self.mainCourse?.setText(self.menuNotReadyMsg)
//                    self.sides?.setText("")
//                }
//            }
//        
//        self.rac_signalForSelector(Selector("willActivate"))
//            .toSignalProducer()
//            .flatMap(.Latest) { _ in
//                return self.menuService.fetchTodaysMenu()
//            }
//            .startWithSignal { signal, disposable in
//            
//                // TODO: Figure out how to make this more declarative.
//                signal.observe { event in
//                    switch event {
//                        case let .Next(fetchedMenu):
//                            self.menu.value = fetchedMenu
//                        case .Failed(_):
//                            self.mainCourse?.setText(self.fetchMenuErrorMsg)
//                        default:
//                            break
//                    }
//                }
//            }
        
    
//        self.viewModel.headline.producer.observeOn(UIScheduler()).startWithNext { headline in
//            self.mainCourse?.setText(headline)
//        }
    }
    
    
    // MARK: - Helpers
    
//    func fetchMenu() {
//        do {
//            try self.menu = menuStorage.loadMenu()
//        } catch {
//            self.mainCourse?.setText(menuNotReadyMsg)
//            self.sides?.setText("")
//        }
//    }

}
