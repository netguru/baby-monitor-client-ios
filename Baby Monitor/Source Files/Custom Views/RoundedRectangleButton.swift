//
//  RoundedRectangleButton.swift
//  Baby Monitor
//

import UIKit

class RoundedRectangleButton: UIButton {

    init(title: String, backgroundColor: UIColor, borderColor: UIColor? = nil) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = 1.0
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
}
