use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def shared_pods
    pod 'ObjectMapper', '~> 0.17'
end

target 'TodaysReactiveMenu' do
    platform :ios, '9.0'
    
    shared_pods
    pod 'Fabric', '~> 1.6.0'
    pod 'Crashlytics', '~> 3.4.0'
    pod 'PureLayout', '~> 3.0.1'
    pod 'ReactiveCocoa', '4.0.0-alpha-3'
end

target 'TodaysReactiveMenuTests' do

end

target 'TodaysReactiveMenuWatch Extension' do
    platform :watchos, '2.0'
    
    shared_pods
end
