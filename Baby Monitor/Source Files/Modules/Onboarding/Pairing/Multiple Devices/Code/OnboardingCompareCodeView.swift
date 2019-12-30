//
//  OnboardingCompareCodeView.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingCompareCodeView: BaseOnboardingView {

    let backButtonItem = UIBarButtonItem(
       image: #imageLiteral(resourceName: "arrow_back"),
       style: .plain,
       target: nil,
       action: nil
    )

    private let codeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    override init() {
        super.init()
        setup()
    }

    func update(codeText: String) {
        codeLabel.attributedText = codeText.withKerning(10)
            .withFont(.customFont(withSize: .giant, weight: .semibold))
            .withColor(.white)
    }

    private func setup() {
        addSubview(codeLabel)
        codeLabel.addConstraints {[
            $0.equalTo(self, .leading, .leading, constant: 12),
            $0.equal(.centerX)
        ]
        }
        guard let descriptionBottomAnchor = descriptionBottomAnchor else { return }
        NSLayoutConstraint.activate([
            codeLabel.topAnchor.constraint(equalTo: descriptionBottomAnchor, constant: 100)
        ])
    }

}

extension Reactive where Base: OnboardingCompareCodeView {

    var backButtonTap: ControlEvent<Void> {
       return base.backButtonItem.rx.tap
   }
}
