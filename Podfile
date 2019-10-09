plugin 'cocoapods-keys', {
  :project => "BabyMonitor",
  :keys => [
    "FirebaseServerKey"
  ]}

# Uncomment the next line to define a global platform for your project
  platform :ios, '11.0'
  use_frameworks!
  inhibit_all_warnings!

def shared_pods
    pod 'Firebase/Core', '~> 5.15.0'
    pod 'Firebase/Messaging', '~> 5.15.0'
    pod 'Firebase/Storage', '~> 5.15.0'
end

target 'Baby Monitor' do
  shared_pods
  pod 'SwiftLint', '~> 0.27.0'
  pod 'RealmSwift', '~> 3.19.0'
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  pod 'RxDataSources', '~> 3.0'
  pod 'PocketSocket', '~> 1.0.1'
  pod 'AudioKit', '~> 4.9.0'
  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.14.0'
  
  target 'Baby MonitorTests' do
    inherit! :search_paths
    shared_pods
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest', '~> 4.0'
  end

end
