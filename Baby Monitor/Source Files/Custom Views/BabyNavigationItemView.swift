//
//  BabyNavigationItemView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class BabyNavigationItemView: UIView {

    fileprivate var isVisible = false
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

    fileprivate let arrowButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleToFill
        button.setImage(#imageLiteral(resourceName: "arrowDown"), for: .normal)
        return button
    }()

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

extension Reactive where Base: BabyNavigationItemView {
    var tap: ControlEvent<Void> {
        return ControlEvent(events: base.arrowButton.rx.tap
            .do(onNext: { _ in
                self.base.isVisible.toggle()
                let arrowImage = self.base.isVisible ? #imageLiteral(resourceName: "arrowUp") : #imageLiteral(resourceName: "arrowDown")
                self.base.arrowButton.setImage(arrowImage, for: .normal)
            }))
    }
}
