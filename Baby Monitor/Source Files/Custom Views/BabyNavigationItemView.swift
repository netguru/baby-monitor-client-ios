//
//  BabyNavigationItemView.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

final class BabyNavigationItemView: UIView {

    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(withSize: .body, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    fileprivate let pulsatoryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return view
    }()

    init(mode: AppMode) {
        super.init(frame: .zero)
        setup(mode: mode)
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhotoImageView() {
        photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
    }

    func updateBabyName(_ name: String?) {
        nameLabel.text = name
    }
    
    func updateBabyPhoto(_ photo: UIImage) {
        photoImageView.image = photo
    }
    
    func firePulse() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 4, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.fillColor = UIColor.babyMonitorLightGreen.cgColor
        let point = pulsatoryView.bounds.origin
        let frame = pulsatoryView.frame
        pulsatingLayer.position =  CGPoint(
            x: point.x + (frame.width / 2),
            y: point.y + (frame.height / 2)
        )
        pulsatoryView.layer.addSublayer(pulsatingLayer)
        let scaleAnimation = CALayerBasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 4
        let colorAnimation = CALayerBasicAnimation(keyPath: "fillColor")
        colorAnimation.toValue = UIColor(named: "darkPurple")!.cgColor
        [scaleAnimation, colorAnimation].forEach {
            $0.duration = 2
            $0.delegate = self
            $0.layer = pulsatingLayer
            pulsatingLayer.add($0, forKey: nil)
        }
    }
    
    // MARK: - View setup
    private func setup(mode: AppMode) {
        backgroundColor = .clear
        addSubview(stackView)
        stackView.addConstraints {
            $0.equalEdges()
        }
        switch mode {
        case .baby:
            [nameLabel, pulsatoryView].forEach {
                stackView.addArrangedSubview($0)
            }
            pulsatoryView.addConstraints {[
                $0.equalTo(stackView, .height, .height, multiplier: 0.5),
                $0.equalTo(pulsatoryView, .width, .height)
            ]
            }
        case .parent:
            [photoImageView, nameLabel].forEach {
                stackView.addArrangedSubview($0)
            }
            photoImageView.addConstraints {[
                $0.equalTo(self, .height, .height, multiplier: 0.6),
                $0.equalTo(photoImageView, .width, .height)
            ]
            }
        case .none:
            break
        }
    }
}

extension BabyNavigationItemView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let layerAnimation = anim as? CALayerBasicAnimation else {
            return
        }
        layerAnimation.layer?.removeFromSuperlayer()
    }
}

extension Reactive where Base: BabyNavigationItemView {
    
    var babyName: Binder<String> {
        return Binder(base.nameLabel, binding: { nameLabel, name in
            nameLabel.text = name
        })
    }
}
