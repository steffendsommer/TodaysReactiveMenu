//
//  TodaysMenuViewModel.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import Foundation
import ReactiveCocoa


class TodaysMenuViewModel: NSObject {
    
    private var viewIsActive = MutableProperty<Bool>(false)
    
    private var menu         = MutableProperty<Menu?>(nil)
    var headline             = ConstantProperty<String>("Today's Menu")
    var subHeadline          = ConstantProperty<String>("at\nUnwire")
    var mainCourse           = MutableProperty("Please sit tight while the chef gets Today's Menu..")
    var logo                 = ConstantProperty<UIImage?>(UIImage(named: "Logo"))
    var sides                = MutableProperty<String>("")
    var cake                 = ConstantProperty<String>("CAKE DAY")
    var hideCakeBanner       = MutableProperty<Bool>(true)
    var hideMenu             = MutableProperty<Bool>(true)
    
    
    // MARK: Object Life Cycle -
    
    override init() {
        super.init()
        
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
        
        self.viewIsActive <~ merge([active, inactive])
        
        // Handle fetching of menu.
        // Initially fetch the menu.
        let fetchedMenu = fetchTodaysMenu()
            |> on(error: { _ in
                // TODO: Make this more declarative.
                self.mainCourse.put("The chef made an unfortunate mistake while getting Today's Menu. Please come back later.")
            })
        
        // Fetch the menu every time the view gets active - skipping the first time as it has already been downloaded.
        self.viewIsActive.producer
            |> filter { isActive in
                return isActive
            }
            |> skip(1)
            |> start(next: { _ in
                // TODO: Make this more declarative.
                fetchedMenu |> start()
            })
        
        self.menu <~ fetchedMenu
            |> observeOn(QueueScheduler.mainQueueScheduler)
            |> ignoreError
    
        // Make sure, we're only showing the menu when it's actually the menu of today.
        self.hideMenu <~ self.menu.producer
            |> ignoreNil
            |> map { menu in
                !NSCalendar.currentCalendar().isDateInToday(menu.servedAt!)
            }
    
        let fetchedMainCourse = self.menu.producer
            |> ignoreNil
            |> map { menu in
                menu.mainCourse!
            }
        
        let menuReadyNotice = self.hideMenu.producer
            |> filter { shouldHide in
                shouldHide
            }
            |> map { _ in
                "The chef is working hard on getting Today's Menu ready. Please come back later."
            }
        
        self.mainCourse <~ merge([fetchedMainCourse, menuReadyNotice])
        
        self.sides <~ self.menu.producer
            |> ignoreNil
            |> map { menu in
                menu.sides!
            }
        
        // Handle the showing of the cake banner.
        let anyCake = self.menu.producer
            |> ignoreNil
            |> map { menu in
                !menu.cake!
            }
        
        self.hideCakeBanner <~ combineLatest(self.hideMenu.producer, anyCake)
            |> map { shouldHideMenu, cakeToday in
                shouldHideMenu || !cakeToday
            }

    }
    
}
