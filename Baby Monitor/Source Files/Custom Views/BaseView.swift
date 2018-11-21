//
//  BaseView.swift
//  Baby Monitor
//

import UIKit

/// This class should be used in case of creating new view class.
/// For now it is only for not writing `required init?(coder aDecoder: NSCoder)`.
class BaseView: UIView {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "back"))
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
