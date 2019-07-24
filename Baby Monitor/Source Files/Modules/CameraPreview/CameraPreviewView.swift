//
//  CameraPreviewView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class CameraPreviewView: BaseView {
    
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
        activityIndicatorView.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.centerY)
        ]}
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
}
