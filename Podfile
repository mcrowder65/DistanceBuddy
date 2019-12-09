
platform :ios, '10.0'
use_frameworks!

def shared_pods
    pod 'SwiftDate', '~> 6.0'
    pod 'SwiftLint', '~> 0.36.0'
    pod 'SwiftyPickerPopover', '~> 6.6.6'
    pod 'PromisesSwift', '~> 1.2.8'
    pod 'SwiftFormat/CLI', '~> 0.40.14'
    pod 'Firebase/Analytics', '~> 6.13.0'
    pod 'Firebase/Auth', '~> 6.13.0'
    pod 'Firebase/Firestore', '~> 6.13.0'
    pod 'FirebaseFirestoreSwift', '~> 0.2'
    pod 'AppCenter', '~> 2.5.1'
    pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '4.4.1'
end

target 'DistanceBuddy' do
    shared_pods
end

target 'DistanceBuddyTests' do
    shared_pods
end
