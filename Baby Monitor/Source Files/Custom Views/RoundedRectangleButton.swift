//
//  RoundedRectangleButton.swift
//  Baby Monitor
//

import UIKit

final class RoundedRectangleButton: UIButton {

    /// Initializes button
    ///
    /// - Parameters:
    ///     - title: title of button
    ///     - backgroundColor: background color of button
    ///     - borderColor: border color of button
    init(title: String, backgroundColor: UIColor? = nil, borderColor: UIColor? = nil, borderWidth: CGFloat = 1.0) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        }
    }

    @available(*, unavailable, message: "Use init(title: String, backgroundColor: UIColor) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// - SeeAlso: UIView.layoutSubviews()
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
}
