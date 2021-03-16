source 'https://github.com/AudioKit/Specs.git'
source 'https://cdn.cocoapods.org/'

plugin 'cocoapods-keys', {
  :project => "BabyMonitor",
  :keys => [
    "FirebaseServerKey"
  ]}

  platform :ios, '12.0'
  use_frameworks!
  inhibit_all_warnings!

def shared_pods
    pod 'Firebase/Core', '~> 6.21.0'
    pod 'Firebase/Messaging', '~> 6.21.0'
    pod 'Firebase/Storage', '~> 6.21.0'
end

target 'Baby Monitor' do
  shared_pods
  pod 'SwiftLint', '~> 0.39.0'
  pod 'RealmSwift', '~> 4.3.0'
  pod 'RxSwift', '~> 5.1'
  pod 'RxCocoa', '~> 5.1'
  pod 'RxDataSources', '~> 4.0'
  pod 'PocketSocket', '~> 1.0.1'
  pod 'AudioKit', '=5.0.b1'
  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.14.0'
  pod 'GoogleWebRTC', '~> 1.1.29400'
  pod 'SwiftyBeaver', '~> 1.8.4'
  
  target 'Baby MonitorTests' do
    inherit! :search_paths
    shared_pods
    pod 'RxBlocking', '~> 5.1'
    pod 'RxTest', '~> 5.1'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end

  installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          if target.name == "RealmSwift" || target.name == "Realm"
            config.build_settings["EXCLUDED_ARCHS"] = "arm64"
          end
        end
  end
end