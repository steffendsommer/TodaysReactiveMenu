//
//  PushTokenDataManager.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/08/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation

#if DEBUG
    private let env = "sandbox"
#else
    private let env = "production"
#endif


protocol PushTokenDataManagerType {
    var webService: WebServiceType { get }
    var pushTokenResource: PushTokenType { get }
    func submit(token: String)
}

struct PushTokenDataManagerType: PushTokenDataManagerType {
    let webService: WebServiceType
    let pushTokenResource: PushTokenType

    func submit(token: String) {
        let pushToken = PushToken(token: PushToken, platform: .iOS, environment: .Production)
        let resource = pushTokenResource.submit(pushToken)

        webService().load(resource) { result in
            print(result)
        }
    }
}
