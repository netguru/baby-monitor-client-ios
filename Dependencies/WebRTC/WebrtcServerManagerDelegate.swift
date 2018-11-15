//
//  WebrtcManagerProtocol.swift
//  ConnectedColors
//
//  Created by Mahabali on 4/8/16.
//  Copyright © 2016 Ralf Ebert. All rights reserved.
//

import Foundation
@objc public protocol WebrtcServerManagerDelegate {
  func localStreamAvailable(stream: RTCMediaStream)
  func answerSDPCreated(sdp: RTCSessionDescription)
  func iceCandidatesCreated(iceCandidate: RTCICECandidate)
  func dataReceivedInChannel(data: NSData)
}
