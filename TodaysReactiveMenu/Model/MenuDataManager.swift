//
//  MenuDataManager.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 23/08/16.
//  Copyright © 2016 steffendsommer. All rights reserved.
//

import Foundation
import ReactiveCocoa


struct MenuDataManager {

    var menuResource: MenuType

    func todaysMenu() -> SignalProducer<Menu, FetchMenuError> {

    }

    enum FetchMenuError: ErrorType {
        case UnknownError
        case APIError
        case CacheError
    }

    static func fetchTodaysMenuFromCacheOrRemote(menuAPI: RemoteResource) -> SignalProducer<Menu, FetchMenuError> {

        let cacheSharedIdentifier = "menu"

        // Download latest menu and deserialize into a menu instance.
        let fetchMenuFromRemote = menuAPI.latestMenu()
            .mapError { _ in
                return FetchMenuError.APIError
            }
            .flatMap(.Latest) { JSON in
                return Menu.fromJson(JSON)
                    .mapError { error in
                        return FetchMenuError.APIError
                }
        }

        let fetchMenuFromCache = Menu.loadUsingIdentifier(cacheSharedIdentifier)
            .mapError { _ in
                return FetchMenuError.CacheError
        }

        let fetchMenuFromCacheOrRemote = fetchMenuFromCache
            .flatMap(.Latest) { menu in
                return menu.isTodaysMenu() ? SignalProducer<Menu, FetchMenuError>(value: menu) : fetchMenuFromRemote
            }
            .flatMapError { error in
                return (error == FetchMenuError.CacheError) ? fetchMenuFromRemote : SignalProducer<Menu, FetchMenuError>(error: error)
        }

        return fetchMenuFromCacheOrRemote
            .flatMap(.Latest) { menu in
                return menu.saveUsingIdentifier(cacheSharedIdentifier)
                    .map { _ in
                        return menu
                    }
                    .flatMapError { _ in
                        return SignalProducer<Menu, FetchMenuError>(value: menu)
                }
        }
    }
}
