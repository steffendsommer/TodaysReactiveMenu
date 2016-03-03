//
//  AppDelegate.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 24/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import UIKit
import Fabric
import WatchConnectivity
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let menuAPI = TodaysMenuAPI()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Setup Crashlytics
        Fabric.with([Crashlytics.self])
        
        // Register for remote notifications
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Setup initial view
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            window.backgroundColor = UIColor.whiteColor()
            window.rootViewController = TodaysMenuViewController(viewModel: TodaysMenuViewModel(menuAPI: self.menuAPI))
            window.makeKeyAndVisible()
        }
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = ( deviceToken.description as NSString )
                                            .stringByTrimmingCharactersInSet( characterSet )
                                            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        self.menuAPI.submitPushToken(deviceTokenString)
            .startWithFailed { error in
                print("Failed to register push token.")
            }
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        // Push received while being in background mode. Fetch the menu so it's loaded when the app gets opened.
        Menu.fetchTodaysMenuFromCacheOrRemote(self.menuAPI)
            .start { event in
                switch event {
                    case .Next(_):
                        completionHandler(UIBackgroundFetchResult.NewData)
                        break
                    default:
                        completionHandler(UIBackgroundFetchResult.NoData)
                        break
                }
            }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
