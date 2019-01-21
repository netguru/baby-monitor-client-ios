//
//  UIFont+BabyMonitor.swift
//  Baby Monitor
//

import UIKit

extension UIFont {

    enum CustomTextSize: CGFloat {
        case caption = 12
        case small = 14
        case body = 16
        case h3 = 20
        case h2 = 24
        case h1 = 32
    }

    static func customFont(withSize size: CustomTextSize, weight: Weight = .regular) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "Rubik-Regular", size: size.rawValue)!
        case .medium:
            return UIFont(name: "Rubik-Medium", size: size.rawValue)!
        case .bold:
            return UIFont(name: "Rubik-Bold", size: size.rawValue)!
        default:
            return UIFont.systemFont(ofSize: size.rawValue, weight: weight)
        }
    }
}
