//
//  SliderProgressIndicator.swift
//  Baby Monitor

import UIKit

/// A progress indicator view for slider.
final class SliderProgressIndicatorView: UIView {

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

    /// Starts animating a progress indicator and hiding all other views.
    func startAnimating() {
        resultImageView.isHidden = true
        valueLabel.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }

    /// Stops an animation of a progress indicator and hides the view.
    func stopAnimating() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }

    /// Sets a new value on the indicator.
    /// - Parameter value: A text to be set.
    func update(with value: String) {
        valueLabel.text = value
        valueLabel.isHidden = false
        resultImageView.isHidden = true
        loadingIndicator.isHidden = true
    }

    /// Reflects a success or failure of the result.
    /// - Parameter result: A result that should be reflected on the indicator view.
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

    /// Animating an appearance of the view by changing opacity and scaling.
    func animateAppearance() {
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

    private func setup() {
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
}
