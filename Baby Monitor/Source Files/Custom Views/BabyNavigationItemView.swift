//
//  BabyNavigationItemView.swift
//  Baby Monitor
//

import UIKit

final class BabyNavigationItemView: UIView {

    private var isVisible = false
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        //TODO: remove color once assets are available, ticket: https://netguru.atlassian.net/browse/BM-65
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [photoImageView, nameLabel, arrowButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        
        return stackView
    }()

    private let arrowButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onTouchArrowButton), for: .touchUpInside)
        button.imageView?.contentMode = .scaleToFill
        button.setImage(#imageLiteral(resourceName: "arrowDown"), for: .normal)
        return button
    }()

    var onSelectArrow: (() -> Void)?

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setBabyPhoto(_ image: UIImage?) {
        photoImageView.image = image
    }

    func setBabyName(_ name: String?) {
        nameLabel.text = name
    }

    // MARK: - Selectors
    @objc private func onTouchArrowButton() {
        isVisible.toggle()
        let arrowImage = isVisible ? #imageLiteral(resourceName: "arrowUp") : #imageLiteral(resourceName: "arrowDown")
        arrowButton.setImage(arrowImage, for: .normal)
        onSelectArrow?()
    }

    // MARK: - View setup
    private func setup() {
        addSubview(stackView)
        stackView.addConstraints {
            $0.equalEdges()
        }

        photoImageView.addConstraints {[
            $0.equalTo(self, .height, .height, multiplier: 0.8),
            $0.equalTo($0, .width, .height),
            $0.equalConstant(.width, 30)
        ]
        }

        arrowButton.addConstraints {[
            $0.equalTo(self, .height, .height, multiplier: 0.5),
            $0.equalTo(arrowButton, .width, .height, multiplier: 0.8)
        ]
        }
    }
}
