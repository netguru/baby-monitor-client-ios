//
//  ServerViewController.swift
//  Baby Monitor
//

import UIKit
import PocketSocket
import RxSwift

final class ServerViewController: BaseViewController {
    
    private var localVideoTrack: RTCVideoTrack?
    private lazy var pulseView: UIView = {
        let view = UIView()
        view.backgroundColor = .babyMonitorLightGreen
        return view
    }()
    private lazy var rotateCameraButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(#imageLiteral(resourceName: "switchCamera"), for: .normal)
        return view
    }()
    private lazy var nightModeButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(#imageLiteral(resourceName: "nightMode"), for: .normal)
        return view
    }()
    private lazy var buttonsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [rotateCameraButton, nightModeButton])
        view.distribution = .fillEqually
        view.spacing = 32
        return view
    }()
    
    private let settingsBarButtonItem = UIBarButtonItem(
        image: #imageLiteral(resourceName: "settings"),
        style: .plain,
        target: nil,
        action: nil)
    private var timer: Timer?
    private let babyNavigationItemView = BabyNavigationItemView(mode: .baby)
    private let localView = RTCEAGLVideoView()
    private let viewModel: ServerViewModel
    private let bag = DisposeBag()
    
    init(viewModel: ServerViewModel) {
        self.viewModel = viewModel
        super.init()
        view.addSubview(localView)
        view.addSubview(buttonsStackView)
        localView.addConstraints { $0.equalEdges() }
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.settingsTap = settingsBarButtonItem.rx.tap.asObservable()
        babyNavigationItemView.updateBabyName("Franciszek")
        navigationController?.setNavigationBarHidden(false, animated: false)
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true, block: { [weak self] _ in
            self?.babyNavigationItemView.firePulse()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.timer?.fire()
        }
    }
    
    private func setup() {
        navigationItem.titleView = babyNavigationItemView
        navigationItem.rightBarButtonItem = settingsBarButtonItem
        buttonsStackView.addConstraints {[
            $0.equal(.safeAreaBottom, constant: -52),
            $0.equal(.centerX)
        ]
        }
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
