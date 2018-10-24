//
//  ButtonView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class DashboardButtonView: UIView {
    
    fileprivate let button: UIButton = UIButton()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //TODO: remove color once assets are available, ticket: https://netguru.atlassian.net/browse/BM-65
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
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
    
    // MARK: - private functions
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
        ]
        }
        
        textLabel.addConstraints {[
            $0.equal(.bottom),
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.greaterThanOrEqualTo(imageView, .width, .width)
        ]
        }
    }
}

extension Reactive where Base: DashboardButtonView {
    var tap: ControlEvent<Void> {
        return base.button.rx.tap
    }
}
