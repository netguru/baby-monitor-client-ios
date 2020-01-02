//
//  String+NSAttributedString.swift
//  Baby Monitor
//

import UIKit

extension String {

    /// Returns a new instance of NSAttributedString with same text as the string.
    /// - Parameter kerning: a kerning you wish to assign to the text.
    /// - Returns: a new instance of NSAttributedString with given kerning.
    func withKerning(_ kerning: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes([.kern: kerning], range: NSRange(location: 0, length: count))
        return NSAttributedString(attributedString: attributedString)
    }

    /// Convenience getter for an attributed version of the string.
    var attributed: NSAttributedString {
        return NSAttributedString(string: self)
    }
}
