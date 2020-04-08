//
//  CameraPreviewView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class CameraPreviewView: BaseView {

    var shouldHideMicrophoneButton: Bool = true {
        didSet {
            microphoneButton.isHidden = shouldHideMicrophoneButton
        }
    }
    var shouldAnimateMicrophoneButton = true
    let mediaView = StreamVideoView(contentTransform: .none)
    let babyNavigationItemView = BabyNavigationItemView(mode: .parent)
    let settingsBarButtonItem = UIBarButtonItem(
        image: #imageLiteral(resourceName: "settings"),
        style: .plain,
        target: nil,
        action: nil)
    let cancelItemButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowBack"),
                                           style: .plain,
                                           target: nil,
                                           action: nil)
    fileprivate let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    fileprivate let microphoneButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "microphone-icon"), for: .normal)
        button.isHidden = true
        button.adjustsImageWhenHighlighted = false
        return button
    }()

    fileprivate let microphoneHoldPublisher = PublishSubject<Void>()
    fileprivate let microphoneReleasePublisher = PublishSubject<Void>()
    
    override init() {
        super.init()
        setup()
    }
    
    func setupOnLoadingView() {
        babyNavigationItemView.setupPhotoImageView()
    }
    
    // MARK: - Private functions
    private func setup() {
        setupBackgroundImage(UIImage())
        backgroundColor = .gray
        addSubview(mediaView)
        mediaView.addConstraints { $0.equalEdges() }
        addSubview(activityIndicatorView)
        addSubview(microphoneButton)
        activityIndicatorView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY)
        ]
        }
        microphoneButton.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.safeAreaBottom, constant: -52)
        ]
        }
        microphoneButton.addTarget(self, action: #selector(onMicrophoneButtonPressed), for: .touchDown)
        microphoneButton.addTarget(self, action: #selector(onMicrophoneButtonReleased), for: .touchUpInside)
    }

    @objc private func onMicrophoneButtonPressed() {
        microphoneHoldPublisher.onNext(())
        guard shouldAnimateMicrophoneButton else { return }
        addMicrophoneAnimations()
    }

    @objc private func onMicrophoneButtonReleased() {
        microphoneReleasePublisher.onNext(())
        removeAllMicrophoneAnimations()
    }

    private func addMicrophoneAnimations() {
        let scaleAnimation = CABasicAnimation()
        scaleAnimation.valueFunction = CAValueFunction(name: CAValueFunctionName.scale)
        scaleAnimation.fromValue = [1, 1, 1]
        scaleAnimation.toValue = [1.5, 1.5, 1.5]
        scaleAnimation.duration = 0.6
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        scaleAnimation.autoreverses = true
        microphoneButton.layer.add(scaleAnimation, forKey: "transform")
    }

    private func removeAllMicrophoneAnimations() {
        microphoneButton.layer.removeAllAnimations()
    }
}

extension Reactive where Base: CameraPreviewView {
    var babyName: Binder<String> {
        return Binder(base.babyNavigationItemView, binding: { navigationView, name in
            navigationView.updateBabyName(name)
        })
    }
    
    var babyPhoto: Binder<UIImage?> {
        return Binder(base.babyNavigationItemView, binding: { navigationView, photo in
            navigationView.updateBabyPhoto(photo ?? UIImage())
        })
    }
    
    var cancelTap: ControlEvent<Void> {
        return base.cancelItemButton.rx.tap
    }
    
    var settingsTap: ControlEvent<Void> {
        return base.settingsBarButtonItem.rx.tap
    }

    var isLoading: Binder<Bool> {
        return base.activityIndicatorView.rx.isLoading
    }

    var microphoneHoldEvent: Observable<Void> {
        return base.microphoneHoldPublisher.asObservable()
    }

    var microphoneReleaseEvent: Observable<Void> {
        return base.microphoneReleasePublisher.asObservable()
    }
}
