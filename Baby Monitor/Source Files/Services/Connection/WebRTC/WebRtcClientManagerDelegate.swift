//
//  WebrtcManagerProtocol.swift
//  ConnectedColors
//
//  Created by Mahabali on 4/8/16.
//  Copyright © 2016 Ralf Ebert. All rights reserved.
//

import WebRTC

protocol WebRtcClientManagerDelegate: AnyObject {
    func offerSDPCreated(sdp: SessionDescriptionProtocol)
    func remoteStreamAvailable(stream: RTCMediaStream)
    func iceCandidatesCreated(iceCandidate: IceCandidateProtocol)
}
