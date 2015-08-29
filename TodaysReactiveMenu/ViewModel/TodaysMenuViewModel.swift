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
    
    let headline             = ConstantProperty<String>("Today's Menu")
    let subHeadline          = ConstantProperty<String>("at\nUnwire")
    let mainCourse           = MutableProperty("")
    let logo                 = ConstantProperty<UIImage?>(UIImage(named: "Logo"))
    let sides                = MutableProperty<String>("")
    let cake                 = ConstantProperty<String>("CAKE DAY")
    let isCakeServedToday    = MutableProperty<Bool>(true)
    let shouldHideMenu       = MutableProperty<Bool>(true)
    
    
    // MARK: Object Life Cycle -
    
     init() {        
        // Setup RAC bindings.
        self.setupBindings()
    }
    
    
    // MARK: RAC Bindings -
    
    func setupBindings() {
        
        // Handle view being active/inactive
        let active = NSNotificationCenter.defaultCenter().rac_addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil).toSignalProducer()
            |> ignoreError
            |> map { _ in
                true
            }
        let inactive = NSNotificationCenter.defaultCenter().rac_addObserverForName(UIApplicationWillResignActiveNotification, object: nil).toSignalProducer()
            |> ignoreError
            |> map { _ in
                false
            }
        
        let viewIsActive = merge([active, inactive])
        
        // Handle fetching of menu by fetching it every time the view gets active.
        let menu = viewIsActive
            |> filter { isActive in
                return isActive
            }
            |> promoteErrors(NSError)
            |> flatMap(.Latest) { _ in
                return fetchTodaysMenu()
            }
            |> observeOn(UIScheduler())
    
        // Make sure, we're only showing the menu when it's actually the menu of today.
        self.shouldHideMenu <~ menu
            |> ignoreNil
            |> ignoreError
            |> map { menu in
                !menu.isTodaysMenu()
            }
        
        // Make sure to display some informative messages if the menu cannot be fetched.
        let fetchedMainCourse = menu
            |> map { fetchedMenu in
                if (fetchedMenu!.isTodaysMenu()) {
                    return fetchedMenu!.mainCourse!
                } else {
                    return "The chef is working hard on getting Today's Menu ready. Please come back later."
                }
            }
            |> catch { error in
                SignalProducer<String, NoError>(value: "Something went wrong in the kitchen. Please come back later.")
            }
        
        self.mainCourse <~ fetchedMainCourse
        
        self.sides <~ menu
            |> ignoreNil
            |> ignoreError
            |> map { menu in
                menu.sides!
            }
        
        // Handle the showing of the cake banner.
        let anyCake = menu
            |> ignoreNil
            |> ignoreError
            |> map { menu in
                menu.cake!
            }
        
        self.isCakeServedToday <~ combineLatest(self.shouldHideMenu.producer, anyCake)
            |> map { shouldHideMenu, cakeToday in
                shouldHideMenu || !cakeToday
            }

    }

}
