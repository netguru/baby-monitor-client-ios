//
//  WebrtcManagerProtocol.swift
//  ConnectedColors
//
//  Created by Mahabali on 4/8/16.
//  Copyright © 2016 Ralf Ebert. All rights reserved.
//

import Foundation
@objc public protocol WebrtcClientManagerDelegate {

  func offerSDPCreated(sdp: RTCSessionDescription)
  func remoteStreamAvailable(stream: RTCMediaStream)
  func iceCandidatesCreated(iceCandidate: RTCICECandidate)
  func dataReceivedInChannel(data: NSData)
}
