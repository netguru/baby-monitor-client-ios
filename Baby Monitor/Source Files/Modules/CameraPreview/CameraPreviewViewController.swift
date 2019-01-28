//
//  CameraPreviewViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import AVKit

final class CameraPreviewViewController: TypedViewController<CameraPreviewView> {
    
    lazy var videoView = customView.mediaView
    
    private var videoTrack: RTCVideoTrack?
    private let viewModel: CameraPreviewViewModel
    private let bag = DisposeBag()
    
    init(viewModel: CameraPreviewViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: CameraPreviewView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModel()
        viewModel.play()
    }
    
    override func viewDidLayoutSubviews() {
        customView.setupOnLoadingView()
    }
    
    // MARK: - Selectors
    @objc private func didTouchCancelButton() {
        viewModel.selectCancel()
    }
    
    // MARK: - Private functions
    private func setup() {
        navigationItem.leftBarButtonItem = customView.cancelItemButton
        navigationItem.titleView = customView.babyNavigationItemView
        customView.cancelItemButton.target = self
        customView.cancelItemButton.action = #selector(didTouchCancelButton)
    }
    
    private func setupViewModel() {
        viewModel.remoteStream
            .subscribe(onNext: { [unowned self] stream in
                guard let stream = stream else {
                    return
                }
                self.attach(stream: stream)
            })
            .disposed(by: bag)
        viewModel.baby
            .map { $0.name }
            .bind(to: customView.rx.babyName)
            .disposed(by: bag)
        viewModel.baby
            .map { $0.photo ?? UIImage() }
            .bind(to: customView.rx.babyPhoto)
            .disposed(by: bag)
    }
    
    private func attach(stream: MediaStream) {
        guard let stream = stream as? RTCMediaStream else {
            return
        }
        videoTrack = stream.videoTracks[0] as? RTCVideoTrack
        videoTrack?.add(videoView)
    }
}
