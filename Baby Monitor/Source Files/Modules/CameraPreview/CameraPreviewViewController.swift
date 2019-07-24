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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        viewModel.play()
        viewModel.isThisViewAlreadyShown = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        viewModel.stop()
        viewModel.isThisViewAlreadyShown = false
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
        viewModel.remoteStream
            .subscribeOn(MainScheduler.instance)
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
            .map { $0.photo }
            .filter { $0 != nil }
            .distinctUntilChanged()
            .bind(to: customView.rx.babyPhoto)
            .disposed(by: bag)
        viewModel.attachInput(
            cancelTap: customView.rx.cancelTap.asObservable(),
            settingsTap: customView.rx.settingsTap.asObservable())
    }
    
    private func attach(stream: MediaStream) {
        guard let stream = stream as? RTCMediaStream else {
            return
        }
        videoTrack = stream.videoTracks[0] as? RTCVideoTrack
        videoTrack?.add(videoView)
    }
}
