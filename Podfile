plugin 'cocoapods-keys', {
  :project => "BabyMonitor",
  :keys => [
    "FirebaseServerKey"
  ]}

# Uncomment the next line to define a global platform for your project
  platform :ios, '11.0'
  use_frameworks!
  inhibit_all_warnings!
  

target 'Baby Monitor' do

  pod 'SwiftLint', '~> 0.27.0'
  pod 'RealmSwift', '~> 3.11.0'
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  pod 'RxDataSources', '~> 3.0'
  pod 'PocketSocket', '~> 1.0.1'
  pod 'AudioKit', '~> 4.5.4' 
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Storage'

  target 'Baby MonitorTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Firebase'
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest', '~> 4.0'
  end

end

# force the sub specs to use swift version 4.2
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
    
    end
end
