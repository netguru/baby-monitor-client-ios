#
# Overlog.podspec
# Copyright © 2018 Netguru S.A. All rights reserved.
#

Pod::Spec.new do |spec|

  # Metadata

  spec.name = 'RTSPServer'
  spec.version = '0.0.1'
  spec.summary = 'RTSPServer for iOS apps for streaming video'
  spec.homepage = 'https://github.com/OpenWatch/H264-RTSP-Server-iOS'

  spec.author = 'chrisballinger'
  spec.license = 'MIT'

  # Sources

 spec.source = { git: 'https://github.com/OpenWatch/H264-RTSP-Server-iOS', tag: spec.version.to_s }

  spec.source_files = 'RTSPServer/*.{h,m,mm,cpp}'

  # Settings

  spec.requires_arc = true
  spec.ios.deployment_target = '6.0'

  spec.frameworks = 'CoreVideo', 'CoreMedia', 'AVFoundation', 'UIKit', 'Foundation', 'CoreGraphics'
  
  spec.private_header_files = 'RTSPServer/NALUnit.h'


end