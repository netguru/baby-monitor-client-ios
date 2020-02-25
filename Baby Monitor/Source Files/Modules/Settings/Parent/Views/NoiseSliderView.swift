//
//  NoiseSliderView.swift
//  Baby Monitor

import UIKit
import RxSwift
import RxCocoa

/// A slider that sets a noise limit for noise detection mode.
final class NoiseSliderView: UIView {

    fileprivate let sliderValueAfterFinishedTouchesPublisher = PublishSubject<Int>()

    fileprivate lazy var noiseSlider: UISlider = {
        let slider = UISlider()
        let tintColor = UIColor.babyMonitorPurple
        let minimumValueImage = #imageLiteral(resourceName: "volume-mute").withRenderingMode(.alwaysTemplate)
        let maximumValueImage = #imageLiteral(resourceName: "volume-up").withRenderingMode(.alwaysTemplate)
        slider.minimumValueImage = minimumValueImage
        slider.maximumValueImage = maximumValueImage
        slider.tintColor = tintColor
        return slider
    }()

    fileprivate var percentSliderValue: Int {
        return convertSliderValueToPercent(noiseSlider.value)
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.Settings.noiseLevel
        label.font = UIFont.customFont(withSize: .body)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Set a new value on the slider.
    /// - Parameter sliderValue: a new value to be set.
    func update(sliderValue: Int) {
        noiseSlider.setValue(Float(sliderValue) / 100.0, animated: true)
    }

    fileprivate func convertSliderValueToPercent(_ value: Float) -> Int {
        return Int(value * 100)
    }

    private func setup() {
        [titleLabel, noiseSlider].forEach {
            addSubview($0)
        }
        setupConstraints()
        noiseSlider.addTarget(self, action: #selector(onFinishedEditingSlider(_:event:)), for: .touchUpInside)
    }

    @objc private func onFinishedEditingSlider(_ slider: UISlider, event: UIEvent) {
        guard let touch = event.allTouches?.first else { return }
        switch touch.phase {
        case .ended:
            sliderValueAfterFinishedTouchesPublisher.onNext(percentSliderValue)
        default: break
        }
    }

    private func setupConstraints() {
        titleLabel.addConstraints {[
            $0.equal(.top, constant: 4),
            $0.equal(.width),
            $0.equal(.centerX)
        ]
        }
        noiseSlider.addConstraints {[
            $0.equalTo(titleLabel, .top, .bottom, constant: 12),
            $0.equal(.width),
            $0.equal(.centerX)
        ]
        }
    }
}

extension Reactive where Base: NoiseSliderView {

    var noiseSliderValue: Observable<Int> {
        return base.noiseSlider.rx.value.map { [unowned base] floatValue in base.convertSliderValueToPercent(floatValue) }
    }

    var noiseSliderValueOnEnded: Observable<Int> {
        return base.sliderValueAfterFinishedTouchesPublisher.asObserver()
    }

}
