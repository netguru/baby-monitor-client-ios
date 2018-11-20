//
//  WebrtcManagerProtocol.swift
//  ConnectedColors
//
//  Created by Mahabali on 4/8/16.
//  Copyright © 2016 Ralf Ebert. All rights reserved.
//

import WebRTC

@objc public protocol WebRtcClientManagerDelegate {
    func offerSDPCreated(sdp: RTCSessionDescription)
    func remoteStreamAvailable(stream: RTCMediaStream)
    func iceCandidatesCreated(iceCandidate: RTCIceCandidate)
    
}
