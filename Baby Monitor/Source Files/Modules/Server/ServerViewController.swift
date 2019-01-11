//
//  ServerViewController.swift
//  Baby Monitor
//

import UIKit
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
        view.addSubview(localView)
        localView.addConstraints { $0.equalEdges() }
        setup()
    }
    
    private func setup() {
        viewModel.stream
            .subscribe(onNext: { [unowned self] stream in
                self.attach(stream: stream)
            })
            .disposed(by: bag)
        viewModel.startStreaming()
    }
    
    private func attach(stream: MediaStream) {
        guard let stream = stream as? RTCMediaStream else {
            return
        }
        localVideoTrack?.remove(localView)
        localView.renderFrame(nil)
        localVideoTrack = stream.videoTracks[0] as? RTCVideoTrack
        localVideoTrack?.add(localView)
    }
}
