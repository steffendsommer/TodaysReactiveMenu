![Headline image](https://github.com/s0mmer/TodaysReactiveMenu/blob/master/Images/TodaysReactiveMenu.png?raw=true =728x130)

Today's (Reactive) Menu is an example app exploring **ReactiveCocoa 3.0 beta 6** using the **MVVM** pattern and **Swift 1.2**.

Along with the app, a blog post has been created explaining the process. The post can be found here: [http://steffendsommer.com/blog/2015/06/02/todaysreactivemenu-an-example-app-using-reactivecocoa-3-0-mvvm-and-swift/](http://steffendsommer.com/blog/2015/06/02/todaysreactivemenu-an-example-app-using-reactivecocoa-3-0-mvvm-and-swift/).

PS: Sorry, for the menu being in Danish. The lunch provider at my work only publishes the menu in Danish :)

## Setup
The app uses **Carthage** for handling third-party dependencies. To build the app, simply clone the repository, then run `carthage update`, the dependencies will be built as frameworks in the `Carthage/Build` folder (the Xcode project will link to that folder). Carthage itself is easy to install, just download the latest `Carthage.pkg` file from the repo. [Carthage's guide](https://github.com/Carthage/Carthage) contains full instructions.

## Useful resources
ReactiveCocoa 3 is, at the time of writing, still very new and because of that, the resources are limited. Here are some good places to get you started:

 - [ReactiveCocoa 3.0 changelog](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/swift-development/CHANGELOG.md) (make sure to see the implementation, tests and issues as well)
 - Colin Eberhardt's [ReactiveTwitterSearch](https://github.com/ColinEberhardt/ReactiveTwitterSearch)
 - [This](http://nomothetis.svbtle.com/an-introduction-to-reactivecocoa) and [this](http://nomothetis.svbtle.com/reactivecocoa-ii-reacting-to-signals) post by Alexandros Salazar
 - The [reactivecocoa-3](http://stackoverflow.com/questions/tagged/reactive-cocoa-3) tag on SO

## Contribution and questions
Feel free to open an issue or ping me at [@steffendsommer](http://twitter.com/steffendsommer) if you have any questions. I'm fully aware that I took some corners and that I'm far from comfortable with RAC3 yet, so any useful PR's are more than welcome.


## Screenhots
![image](https://github.com/s0mmer/TodaysReactiveMenu/blob/master/Images/screenshot.png?raw=true)