//
//  BaseView.swift
//  Baby Monitor
//

import UIKit

/// This class should be used in case of creating new view class.
class BaseView: UIView {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "base-background"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    
    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackgroundImage(_ image: UIImage?) {
        backgroundImageView.image = image
    }
    
    private func setup() {
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundImageView.addConstraints {
            $0.equalEdges()
        }
    }
}
