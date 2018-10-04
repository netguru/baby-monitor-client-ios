//
//  ButtonView.swift
//  Baby Monitor
//


import UIKit

final class DashboardButtonView: UIView {
    
    private let button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onTouchButton), for: .touchUpInside)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //TODO: remove color once getting image asset
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    var onSelect: (() -> Void)?
    
    init(image: UIImage, text: String) {
        super.init(frame: .zero)
        
        imageView.image = image
        textLabel.text = text
        setup()
    }
    
    @available(*, unavailable, message: "Use init(image:text:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc private func onTouchButton() {
        onSelect?()
    }
    
    //MARK: - private functions
    private func setup() {
        [button, imageView, textLabel].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        button.addConstraints {
            $0.equalEdges()
        }
        
        imageView.addConstraints {[
            $0.equalConstant(.height, 50),
            $0.equalConstant(.width, 50),
            $0.equal(.centerX),
            $0.equal(.top),
            $0.equalTo(textLabel, .bottom, .top, constant: -5)
        ]}
        
        textLabel.addConstraints {[
            $0.equal(.bottom),
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.greaterThanOrEqualTo(imageView, .width, .width)
        ]}
    }
}
