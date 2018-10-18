#
# Overlog.podspec
# Copyright © 2018 Netguru S.A. All rights reserved.
#

Pod::Spec.new do |spec|

  # Metadata

  spec.name = 'RTSPServer'
  spec.version = '0.0.1'
  spec.summary = ''
  spec.homepage = 'Q'

  spec.author = 'X'
  spec.license = 'Q'

  # Sources

 spec.source = { git: 'https://github.com/netguru/xxxxxxx.git', tag: spec.version.to_s }

  spec.source_files = 'RTSPServer/*.{h,m,mm,cpp}'

  # Settings

  spec.requires_arc = true
  spec.ios.deployment_target = '6.0'

  spec.frameworks = 'CoreVideo', 'CoreMedia', 'AVFoundation', 'UIKit', 'Foundation', 'CoreGraphics'
  
  spec.private_header_files = 'RTSPServer/NALUnit.h'


end