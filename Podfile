# Uncomment the next line to define a global platform for your project
  platform :ios, '11.0'
  use_frameworks!
  inhibit_all_warnings!
  

target 'Baby Monitor' do

	pod 'MobileVLCKit', '~> 3.1'
    pod 'SwiftLint', '~> 0.27.0'

  target 'Baby MonitorTests' do
    inherit! :search_paths
    # Pods for testing
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
