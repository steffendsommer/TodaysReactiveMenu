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
        
        let inactive = NSNotificationCenter.defaultCenter().rac_addObserverForName(UIApplicationWillResignActiveNotification, object: nil)
            .toSignalProducer()
            .map { _ in
                false
            }


        let fetchMenu = Menu.fetchTodaysMenuFromCacheOrRemote(self.menuAPI)

        let menuProducer = merge([active, inactive])
            .filter { $0 }
            .mapError { _ in
                return Menu.FetchMenuError.UnknownError
            }
            .flatMap(.Latest) { _ in
                return fetchMenu
            }
            .replayLazily(1)
        

        // Make sure, we're only showing the menu when it's actually the menu of today.
        self.shouldHideMenu <~ menuProducer
            .ignoreError()
            .map { menu in
                !menu.isTodaysMenu()
            }

        // Make sure to display some informative messages if the menu cannot be fetched.
        self.mainCourse <~ menuProducer
            .map { fetchedMenu in
                if (fetchedMenu.isTodaysMenu()) {
                    return fetchedMenu.mainCourse!
                } else {
                    return self.menuNotReadyMsg
                }
            }
            .flatMapError { _ in
                return SignalProducer<String, NoError>(value: self.fetchMenuErrorMsg)
            }

        self.sides <~ menuProducer
            .ignoreError()
            .map { menu in
                menu.sides!
            }
        
        // Handle the showing of the cake banner.
        let anyCake = menuProducer
            .ignoreError()
            .map { menu in
                menu.cake!
            }

        self.isCakeServedToday <~ combineLatest(self.shouldHideMenu.producer, anyCake)
            .map { shouldHideMenu, cakeToday in
                shouldHideMenu || !cakeToday
            }

    }

}
