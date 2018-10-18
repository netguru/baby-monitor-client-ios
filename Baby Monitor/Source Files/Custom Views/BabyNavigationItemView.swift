//
//  BabyNavigationItemView.swift
//  Baby Monitor
//


import UIKit

final class BabyNavigationItemView: UIView {
    
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
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onTouchArrowButton), for: .touchUpInside)
        //TODO: remove color once assets are available, ticket: https://netguru.atlassian.net/browse/BM-65
        button.backgroundColor = .red
        return button
    }()
    
    var onSelectArrow: (() -> Void)?
    
    init(baby: Baby? = nil) {
        super.init(frame: .zero)
        nameLabel.text = baby?.name
        photoImageView.image = baby?.image

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
    
    //MARK: - Selectors
    @objc private func onTouchArrowButton() {
        onSelectArrow?()
    }
    
    //MARK: - View setup
    private func setup() {
        addSubview(stackView)
        stackView.addConstraints {
            $0.equalEdges()
        }
        
        photoImageView.addConstraints {[
            $0.equalTo(self, .height, .height, multiplier: 0.8),
            $0.equalTo($0, .width, .height),
            $0.equalConstant(.width, 20)
        ]}
        
        arrowButton.addConstraints {[
            $0.equalTo(self, .height, .height, multiplier: 0.2),
            $0.equalConstant(.width, 5)
        ]}
    }
}
