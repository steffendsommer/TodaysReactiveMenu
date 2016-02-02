//
//  TodaysMenuViewModel.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import Foundation
import ReactiveCocoa


struct TodaysMenuViewModel {
    
    private let menuAPI: RemoteAPI
    private var watchService: WatchService?
    private let menuNotReadyMsg     = "The chef is working hard on getting Today's Menu ready. Please come back later."
    private let fetchMenuErrorMsg   = "Something went wrong in the kitchen. Please come back later."
    
    let headline                    = ConstantProperty<String>("Today's Menu")
    let subHeadline                 = ConstantProperty<String>("at\nUnwire")
    private let menu                = MutableProperty<Menu?>(nil)
    let mainCourse                  = MutableProperty("")
    let logo                        = ConstantProperty<UIImage?>(UIImage(named: "Logo"))
    let sides                       = MutableProperty<String>("")
    let cake                        = ConstantProperty<String>("CAKE DAY")
    let isCakeServedToday           = MutableProperty<Bool>(true)
    let shouldHideMenu              = MutableProperty<Bool>(true)
    
    
    // MARK: Object Life Cycle -
    
    init(menuAPI: RemoteAPI) {
        self.init(menuAPI: menuAPI, watchService: nil)
    }
    
    init(menuAPI: RemoteAPI, watchService: WatchService?) {
        self.menuAPI = menuAPI
        self.watchService = watchService
        
        // Setup RAC bindings.
        self.setupBindings()
    }
    
    
    // MARK: RAC Bindings -
    
    func setupBindings() {
        
        // Handle view being active/inactive
        let active = NSNotificationCenter.defaultCenter().rac_addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil)
            .toSignalProducer()
            .map { _ in
                true
            }
            .mapError { _ in
                return APIError.RequestFailed
            }
        
        let inactive = NSNotificationCenter.defaultCenter().rac_addObserverForName(UIApplicationWillResignActiveNotification, object: nil)
            .toSignalProducer()
            .map { _ in
                false
            }
            .mapError { _ in
                return APIError.RequestFailed
            }
        

        // Fetch the menu every time the view gets active. Multicast the signal to avoid subscribers causing the menu being fetches multiple times.
        merge([active, inactive])
            .filter { $0 }
            .flatMap(.Latest) { _ in
                Menu.loadUsingIdentifier("menu")
                    .flatMapError { _ in
                        return self.menuAPI.latestMenu()
                            .flatMap(.Latest) { JSON in
                                return Menu.deserializeFromJSON(JSON)
                                    .mapError { error in
                                        return APIError.SerializationFailed
                                    }
                            }
                    }
                }
                .flatMap(.Latest) { menu in
                    return menu.saveUsingIdentifier("menu")
                        .map { _ in
                            return menu
                        }
                        .mapError { error in
                            return APIError.SerializationFailed
                        }
                }
            .startWithSignal { signal, disposable in
            
                // TODO: Figure out how to make this more declarative.
                signal.observe { event in
                    switch event {
                        case let .Next(fetchedMenu):
                            self.menu.value = fetchedMenu
                        case .Failed(_):
                            self.mainCourse.value = self.fetchMenuErrorMsg
                        default:
                            break
                    }
                }
            }


        // Make sure, we're only showing the menu when it's actually the menu of today.
        self.shouldHideMenu <~ self.menu.producer
            .ignoreNil()
            .map { menu in
                !menu.isTodaysMenu()
            }


        // Make sure to display some informative messages if the menu cannot be fetched.
        self.mainCourse <~ self.menu.producer
            .ignoreNil()
            .map { fetchedMenu in
                if (fetchedMenu.isTodaysMenu()) {
                    return fetchedMenu.mainCourse!
                } else {
                    return self.menuNotReadyMsg
                }
            }


        self.sides <~ self.menu.producer
            .ignoreError()
            .ignoreNil()
            .map { menu in
                menu.sides!
            }
        
        
        // Handle the showing of the cake banner.
        let anyCake = self.menu.producer
            .ignoreError()
            .ignoreNil()
            .map { menu in
                menu.cake!
            }

        self.isCakeServedToday <~ combineLatest(self.shouldHideMenu.producer, anyCake)
            .map { shouldHideMenu, cakeToday in
                shouldHideMenu || !cakeToday
            }
        
//        // Send a fetched menu to the watch (if watch service is defined)
//        // TODO: Make this more declarative.
//        self.menu.producer
//            .ignoreNil()
//            .startWithNext { menu in
//                if let service = self.watchService {
//                    service.sendMenu(menu)
//                }
//            }

    }

}
