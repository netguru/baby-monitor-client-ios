#
# Overlog.podspec
# Copyright © 2018 Netguru S.A. All rights reserved.
#

Pod::Spec.new do |spec|

  # Metadata

  spec.name = 'WebRTC'
  spec.version = '0.0.1'
  spec.homepage = 'https://github.com/Mahabali/BonjourWebrtc/'
  spec.summary = 'WebRTC for iOS apps for streaming video'

  spec.author = 'mahabali'
  spec.license = 'MIT'

  # Sources

  spec.source = { :git => 'https://github.com/Mahabali/BonjourWebrtc' }
  spec.source_files = 'WebRTC/**/*.{h,m,swift}'

  # Settings

  spec.requires_arc = true
  spec.ios.deployment_target = '8.0'
  spec.swift_version = '4.2'
  spec.platform = :ios

  spec.frameworks = 'CoreVideo', 'VideoToolbox', 'SystemConfiguration'
  spec.vendored_libraries = 'WebRTC/libs/libWebRTC.a' 
  spec.library = 'c++'
  

end
