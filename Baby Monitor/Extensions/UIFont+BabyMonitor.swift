//
//  UIFont+BabyMonitor.swift
//  Baby Monitor
//

import UIKit

extension UIFont {

    /// Custom font sizes used throught the app
    enum CustomTextSize: CGFloat {
        case caption = 12
        case small = 14
        case body = 16
        case h3 = 20
        case h2 = 24
        case h1 = 32
        case giant = 64
    }

    /// Creates custom font used throught the app
    ///
    /// - Parameters:
    ///     - size: size of the font
    ///     - weight: weight of the font
    /// - Returns: Created font
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
