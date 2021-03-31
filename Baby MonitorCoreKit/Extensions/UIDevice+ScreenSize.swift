//
//  UIDevice+ScreenSize.swift
//  Baby Monitor
//

import UIKit

extension UIDevice {

    /// Indicates if screen size of the device is bigger than 4 inches
    static var screenSizeBiggerThan4Inches: Bool {
        return UIScreen.main.bounds.height > 568
    }

    /// Indicates if screen size of the device is bigger than 4.7 inches
    static var screenSizeBiggerThan4Point7Inches: Bool {
        return UIScreen.main.bounds.height > 667
    }
}
