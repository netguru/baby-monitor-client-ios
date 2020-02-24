//
//  SliderProgressIndicator.swift
//  Baby Monitor

import UIKit

final class SliderProgressIndicatorView: UIView {

    var value: String = "" {
        didSet {
            valueLabel.text = value
            valueLabel.isHidden = false
            resultImageView.isHidden = true
            loadingIndicator.isHidden = true
        }
    }
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "onboarding-oval")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let loadingIndicator = UIActivityIndicatorView()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(withSize: .body)
        label.textColor = .babyMonitorPurple
        label.textAlignment = .center
        return label
    }()

    private let resultImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .babyMonitorPurple
        return view
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        [backgroundImageView, loadingIndicator, valueLabel, resultImageView].forEach {
            addSubview($0)
            $0.addConstraints {
                $0.equalEdges()
            }
        }
        loadingIndicator.style = .gray
        loadingIndicator.isHidden = true
        resultImageView.isHidden = true
    }

    func startAnimating() {
        resultImageView.isHidden = true
        valueLabel.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }

    func stopAnimating() {
        valueLabel.isHidden = false
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }

    func update(with result: Result<()>) {
        switch result {
        case .success:
            resultImageView.image = #imageLiteral(resourceName: "onboarding-completed")
        case .failure:
            resultImageView.image = #imageLiteral(resourceName: "onboarding-error")
        }
        resultImageView.isHidden = false
        stopAnimating()
    }

    func animateAppearence() {
        isOpaque = true

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.duration = 0.3
        layer.add(opacityAnimation, forKey: nil)

        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.valueFunction = CAValueFunction(name: CAValueFunctionName.scale)
        scaleAnimation.fromValue = [0, 0, 0]
        scaleAnimation.toValue = [1, 1, 1]
        scaleAnimation.duration = 0.3
        layer.add(scaleAnimation, forKey: nil)
    }
}
