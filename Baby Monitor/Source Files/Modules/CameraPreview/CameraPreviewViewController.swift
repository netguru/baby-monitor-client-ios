//
//  CameraPreviewViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import AVKit
import WebRTC

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        viewModel.play()
        viewModel.shouldPlayPreview = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        viewModel.stop()
        viewModel.shouldPlayPreview = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customView.setupOnLoadingView()
    }
    
    // MARK: - Private functions
    private func setup() {
        view.backgroundColor = .babyMonitorDarkGray
        navigationItem.leftBarButtonItem = customView.cancelItemButton
        navigationItem.rightBarButtonItem = customView.settingsBarButtonItem
        navigationItem.titleView = customView.babyNavigationItemView
    }
    
    private func setupViewModel() {
        setupStream()
        viewModel.baby
            .map { $0.name }
            .bind(to: customView.rx.babyName)
            .disposed(by: bag)
        viewModel.baby
            .map { $0.photo }
            .filter { $0 != nil }
            .distinctUntilChanged()
            .bind(to: customView.rx.babyPhoto)
            .disposed(by: bag)
        viewModel.state
            .map { $0 == .connecting }
            .bind(to: customView.rx.isLoading)
            .disposed(by: bag)
        viewModel.attachInput(
            cancelTap: customView.rx.cancelTap.asObservable(),
            settingsTap: customView.rx.settingsTap.asObservable())
        viewModel.streamResettedPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.setupStream()
            })
            .disposed(by: bag)
    }
    
    private func setupStream() {
        viewModel.remoteStream
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] stream in
                guard let stream = stream else {
                    return
                }
                self?.attach(stream: stream)
            })
            .disposed(by: bag)
    }
    
    private func attach(stream: MediaStream) {
        guard let stream = stream as? RTCMediaStream else {
            return
        }
        videoTrack?.remove(videoView)
        videoTrack = stream.videoTracks[0]
        videoTrack?.add(videoView)
    }
}
