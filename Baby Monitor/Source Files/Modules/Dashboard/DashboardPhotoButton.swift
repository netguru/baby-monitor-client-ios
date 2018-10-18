//
//  DashboardPhotoButton.swift
//  Baby Monitor
//

import UIKit

final class DashboardPhotoButtonView: BaseView {
    
    private let button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onTouchButton), for: .touchUpInside)
        button.layer.cornerRadius = 90
        button.backgroundColor = .lightGray
        button.setTitleColor(.darkText, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        
        return button
    }()
    
    var onSelect: (() -> Void)?
    
    init(baby: Baby? = nil) {
        super.init()
        
        setup()
        updateImage(baby?.photo)
    }
    
    func setPhoto(_ image: UIImage?) {
        updateImage(image)
    }
    
    // MARK: - Selectors
    @objc private func onTouchButton() {
        onSelect?()
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
