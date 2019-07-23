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
}
