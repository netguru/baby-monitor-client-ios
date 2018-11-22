//
//  ServerViewController.swift
//  Baby Monitor
//

import UIKit
import WebRTC
import PocketSocket
import RxSwift

final class ServerViewController: BaseViewController {
    
    private let localView = RTCEAGLVideoView()
    private var localVideoTrack: RTCVideoTrack?
    private let viewModel: ServerViewModel
    private let bag = DisposeBag()
    
    init(viewModel: ServerViewModel) {
        self.viewModel = viewModel
        super.init()
        setup()
    }
    
    private func setup() {
        viewModel.localStream
            .subscribe(onNext: { [unowned self] stream in
                self.attach(stream: stream)
            })
            .disposed(by: bag)
        viewModel.startStreaming()
    }
    
    private func attach(stream: MediaStreamProtocol) {
        guard let stream = stream as? RTCMediaStream else {
            return
        }
        localVideoTrack?.remove(localView)
        localView.renderFrame(nil)
        localVideoTrack = stream.videoTracks[0]
        localVideoTrack?.add(localView)
    }
}
