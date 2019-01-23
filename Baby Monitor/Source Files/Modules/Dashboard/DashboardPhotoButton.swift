//
//  DashboardPhotoButton.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class DashboardPhotoButtonView: UIView {
    
    fileprivate let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "darkPurple"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        return button
    }()
    private let buttonPlaceholder: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "child"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let buttonTitle: UILabel = {
        let label = UILabel()
        label.text = Localizable.Dashboard.addPhoto
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private let backgroundView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "oval"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private lazy var placeholderStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonPlaceholder, buttonTitle])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable, message: "Use init(image:text:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhoto(_ image: UIImage?) {
        updateImage(image)
        DispatchQueue.main.async {
            self.setupPhotoButtonLayer()
        }
    }
    
    func setupPhotoButtonLayer() {
        button.layer.cornerRadius = button.frame.width / 2
    }
    
    // MARK: - private functions
    private func setup() {
        [placeholderStackView, button].forEach {
            backgroundView.addSubview($0)
        }
        addSubview(backgroundView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundView.addConstraints {
            [$0.equal(.centerX)]
        }
        backgroundView.addConstraints {
            $0.equalEdges()
        }
        
        button.addConstraints {
            [$0.equalTo(self, .width, .width, multiplier: 0.53),
            $0.equalTo($0, .width, .height),
            $0.equal(.centerX),
            $0.equal(.centerY)]
        }
        
        placeholderStackView.addConstraints {
            [$0.equal(.centerX),
            $0.equal(.centerY),
            $0.equalTo(button, .width, .width)]
        }
    }
    
    private func updateTitle() {
        if button.image(for: .normal) == nil {
            placeholderStackView.isHidden = false
        } else {
            placeholderStackView.isHidden = true
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
