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
        super.init(viewMaker: CameraPreviewView(),
                   analytics: viewModel.analytics,
                   analyticsScreenType: .parentCameraPreview)
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
        customView.shouldAnimateMicrophoneButton = viewModel.isMicrophoneAccessGranted
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
        viewModel.connectionStatusObservable
            .map { $0 == .connecting }
            .bind(to: customView.rx.isLoading)
            .disposed(by: bag)
        viewModel.attachInput(
            cancelTap: customView.rx.cancelTap.asObservable(),
            settingsTap: customView.rx.settingsTap.asObservable(),
            microphoneHoldEvent: customView.rx.microphoneHoldEvent,
            microphoneReleaseEvent: customView.rx.microphoneReleaseEvent)
        viewModel.streamResettedPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.setupStream()
            }).disposed(by: bag)
        viewModel.noMicrophoneAccessPublisher
            .subscribe(onNext: { [weak self] in
                self?.showNoMicrophoneAccessAlert()
            }).disposed(by: bag)
    }
    
    private func setupStream() {
        viewModel.remoteStream
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] stream in
                guard let stream = stream else {
                    return
                }
                self?.attach(stream: stream)
            })
            .disposed(by: bag)
        viewModel.remoteStreamErrorMessageObservable
            .subscribe(onNext: { [weak self] message in
                self?.handleStreamError(errorMessage: message)
            }).disposed(by: bag)
    }
    
    private func attach(stream: WebRTCMediaStream) {
        guard let stream = stream as? RTCMediaStream else {
            return
        }
        videoTrack?.remove(videoView)
        videoTrack = stream.videoTracks[0]
        videoTrack?.add(videoView)
        customView.shouldHideMicrophoneButton = false
    }

    private func handleStreamError(errorMessage: String) {
        let alertController = UIAlertController(title: Localizable.Server.streamError, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Localizable.General.ok, style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    private func showNoMicrophoneAccessAlert() {
        let alertController = UIAlertController(title: Localizable.Onboarding.BabySetup.microphonePermissionsDenied, message: Localizable.Server.noMicrophoneAccessMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Localizable.General.ok, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
