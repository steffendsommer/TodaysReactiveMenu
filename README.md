<img src="https://github.com/s0mmer/TodaysReactiveMenu/blob/master/Images/TodaysReactiveMenu.png?raw=true" />

Today's (Reactive) Menu is an example app exploring **ReactiveCocoa 4**, **MVVM**, **Swift 2** and **watchOS 2**.

Along with the app, a blog post has been created explaining the process. The post can be found [here](http://steffendsommer.com/blog/2015/06/02/todaysreactivemenu-an-example-app-using-reactivecocoa-3-0-mvvm-and-swift/). Please keep in mind that things might have changed slightly since that blog post was made.

I'm sorry that the API return menus in Danish, but it is unfortunately how the lunch provider publishes it. I might consider doing some OCR at some point.

## Setup
The app uses **[CocoaPods](https://cocoapods.org)** for handling third-party dependencies. To build the app, simply clone the repository and then run `pod install`.

## Versions
I'll include any major/minor version bumps:

- **1.2**: 👯 Let there be POP! A lot has been refactored, and a lot of protocols and protocol extensions has been added. Watch app should now work without the phone.
- **1.1**: ⌚️ Apple Watch support using watchOS 2.
- **1.0**: Initial version. Supports RAC 4 and Swift 2.

## TODO
I have a lot of ideas for the project, here are some of the stuff I anticipate to work on:

- Add tests.
- Add support for up-/down voting a menu.
- Rewrite the UI logic.
- Make backend in Swift and move to this repo.

## Useful resources
ReactiveCocoa 4 is, at the time of writing, still very new and because of that, the resources are limited. Here are some good places to get you started:

 - [ReactiveCocoa's changelog](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/swift-development/CHANGELOG.md) (make sure to see the implementation, tests and issues as well)
 - Colin Eberhardt's [ReactiveTwitterSearch](https://github.com/ColinEberhardt/ReactiveTwitterSearch)
 - [This](http://nomothetis.svbtle.com/an-introduction-to-reactivecocoa) and [this](http://nomothetis.svbtle.com/reactivecocoa-ii-reacting-to-signals) post by Alexandros Salazar
 - The [reactivecocoa-3](http://stackoverflow.com/questions/tagged/reactive-cocoa-3) tag on SO

Note that resources using RAC3 might also apply to RAC4 as the difference is not that big (see the changelog for more information).

## Contribution and questions
Feel free to open an issue or ping me at [@steffendsommer](http://twitter.com/steffendsommer) if you have any questions. I'm fully aware that I took some corners and that I'm far from comfortable with RAC4 yet, so any useful PR's are more than welcome.


## Screenshots
📱 Main view | 📱 Error view
:-------------: | :-------------:
<img src="https://raw.githubusercontent.com/s0mmer/TodaysReactiveMenu/develop/Images/screenshot01.png" width="300px" />  | <img src="https://raw.githubusercontent.com/s0mmer/TodaysReactiveMenu/develop/Images/screenshot02.png" width="300px" />
⌚️ Main app view | ⌚️ Glance
<img src="https://raw.githubusercontent.com/s0mmer/TodaysReactiveMenu/develop/Images/watch_screenshot01.png" />  | <img src="https://raw.githubusercontent.com/s0mmer/TodaysReactiveMenu/develop/Images/watch_screenshot02.png" />

## License
TodaysReactiveMenu is available under the MIT license. See the LICENSE file for more info.
