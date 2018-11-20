//
//  ServerViewController.swift
//  Baby Monitor
//

import UIKit
import WebRTC
import PocketSocket

final class ServerViewController: BaseViewController {
    
    private let localView = RTCEAGLVideoView()
    private var localVideoTrack: RTCVideoTrack?
    private let viewModel: ServerViewModel
    
    init(viewModel: ServerViewModel) {
        self.viewModel = viewModel
        super.init()
        setup()
    }
    
    private func setup() {
        view.addSubview(localView)
        localView.addConstraints { $0.equalSafeAreaEdges() }
        viewModel.didLoadLocalStream = { [unowned self] stream in
            self.attach(stream: stream)
        }
        viewModel.startStreaming()
    }
    
    private func attach(stream: RTCMediaStream) {
        localVideoTrack?.remove(localView)
        localView.renderFrame(nil)
        localVideoTrack = stream.videoTracks[0]
        localVideoTrack?.add(localView)
    }
}
