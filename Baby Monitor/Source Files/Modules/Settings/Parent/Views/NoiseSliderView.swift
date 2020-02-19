//
//  NoiseSliderView.swift
//  Baby Monitor

import UIKit
import RxSwift
import RxCocoa

final class NoiseSliderView: UIView {

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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.Settings.noiseLevel
        label.font = UIFont.customFont(withSize: .body)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    init(noiseLoudnessFactorLimit: Int) {
        super.init(frame: .zero)
        noiseSlider.value = Float(noiseLoudnessFactorLimit) / 100.0
        setup()
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        [titleLabel, noiseSlider].forEach {
            addSubview($0)
        }
        setupConstraints()
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
        return base.noiseSlider.rx.value.map { Int($0 * 100) }
    }

}
