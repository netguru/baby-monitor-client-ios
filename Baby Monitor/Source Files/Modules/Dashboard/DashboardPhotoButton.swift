//
//  DashboardPhotoButton.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class DashboardPhotoButtonView: BaseView {
    
    fileprivate let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 90
        button.backgroundColor = .lightGray
        button.setTitleColor(.darkText, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    func setPhoto(_ image: UIImage?) {
        updateImage(image)
    }
    
    // MARK: - private functions
    private func setup() {
        [button].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        button.addConstraints {[
            $0.equalConstant(.height, 180),
            $0.equalConstant(.width, 180),
            $0.equal(.centerX),
            $0.equal(.top, constant: 30)
        ]
        }
    }
    
    private func updateTitle() {
        if button.image(for: .normal) == nil {
            button.setTitle(Localizable.Dashboard.addPhoto, for: .normal)
        } else {
            button.setTitle(nil, for: .normal)
        }
    }
    
    private func updateImage(_ image: UIImage?) {
        button.setImage(image, for: .normal)
        updateTitle()
    }
}

extension Reactive where Base: DashboardPhotoButtonView {
    
    var tap: ControlEvent<Void> {
        return base.button.rx.tap
    }
    
    var photo: Binder<UIImage?> {
        return base.button.rx.image(for: .normal)
    }
}
