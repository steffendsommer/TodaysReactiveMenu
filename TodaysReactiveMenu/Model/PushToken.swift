//
//  PushToken.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/08/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation


enum Platform {
    case iOS = "ios"
    case Android = "android"
}

enum Environment {
    case sandbox = "sandbox"
    case production = "production"
}

protocol PushTokenType {
    var tokenKey: String { get }
    var platform: Platform { get }
    var environment: Environment { get }
}


struct PushToken {
    let token: String
    let platform: Platform
    let environment: Environment
}

extension PushToken {
    func submit() -> WebResource<PushToken> {
        return WebResource<PushToken>(url: NSURL(string: "https://todays-menu.herokuapp.com/api/v1/devices"), parseJSON: nil)
    }
}
