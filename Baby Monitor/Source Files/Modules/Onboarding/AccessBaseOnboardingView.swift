//
//  AccessBaseOnboardingView.swift
//  Baby Monitor
//

import Foundation
import RxSwift

final class AccessBaseOnboardingView: BaseOnboardingView {
    
    private let accessDescriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.customFont(withSize: .caption, weight: .medium)
        view.numberOfLines = 0
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    override init() {
        super.init()
        update(image: UIImage())
        setup()
    }
    
    func update(accessDescription: String) {
        accessDescriptionLabel.text = accessDescription
    }
    
    private func setup() {
        addSubview(accessDescriptionLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        accessDescriptionLabel.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.leading, constant: 39),
            $0.equalTo(self, .bottom, .safeAreaBottom, constant: -63)
        ]
        }
        imageViewTopConstraint?.isActive = false
        imageView.addConstraints {[
            $0.equalTo(accessDescriptionLabel, .bottom, .top, constant: -30)
        ]
        }
    }
}
