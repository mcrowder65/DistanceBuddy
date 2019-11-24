
platform :ios, '10.0'
use_frameworks!

def shared_pods
    pod 'SwiftDate', '~> 6.0'
    pod 'SwiftLint'
    pod 'SwiftyPickerPopover'
    pod 'PromisesSwift'
    pod 'SwiftFormat/CLI'
    pod 'Firebase/Analytics'
    pod 'Firebase/Auth'
    pod 'Firebase/Firestore'
    pod 'FirebaseFirestoreSwift'
    pod 'AppCenter'
    pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '4.4.1'
end

target 'DistanceBuddy' do
    shared_pods
end

target 'DistanceBuddyTests' do
    shared_pods
end
