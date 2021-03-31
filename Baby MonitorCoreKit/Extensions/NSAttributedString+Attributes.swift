//
//  NSAttributedString+Attributes.swift
//  Baby Monitor
//

import UIKit

extension NSAttributedString {

    /// Returns a new instance of NSAttributedString with same contents and attributes with kerning added.
    /// - Parameter kerning: a kerning you wish to assign to the text.
    /// - Returns: a new instance of NSAttributedString with given kerning.
    func withKerning(_ kerning: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttributes([.kern: kerning], range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }

    /// Returns a new instance of NSAttributedString with same contents and attributes with color added.
    /// - Parameter color: a color you wish to assign to the text.
    /// - Returns: a new instance of NSAttributedString with given color.
    func withColor(_ color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttributes([.foregroundColor: color], range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }

    /// Returns a new instance of NSAttributedString with same contents and attributes with font attribute added.
    /// - Parameter font: a font you wish to assign to the text.
    /// - Returns: a new instance of NSAttributedString with given font.
    func withFont(_ font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttributes([.font: font], range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }

    /// Returns a new instance of NSAttributedString with same contents and attributes with line spacing added.
    /// - Parameter spacing: value for spacing you wish to assign to the text.
    /// - Returns: a new instance of NSAttributedString with given line spacing.
    func withLineSpacing(_ spacing: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }

    /// Returns a new instance of NSAttributedString with same contents and attributes with given text alignment and line spacing.
    /// - Parameters:
    ///      - spacing: value for spacing you wish to assign to the text.
    ///      - alignment: text alignment you wish to assign.
    /// - Returns: a new instance of NSAttributedString with given text alignment.
    func withLineSpacing(_ spacing: CGFloat, _ alignment: NSTextAlignment) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }

    /// Returns a new instance of NSAttributedString with same contents and attributes with strike through added.
    /// - Parameter style: value for style you wish to assign to the text.
    /// - Returns: a new instance of NSAttributedString with given strike through.
    func withStrikeThrough(_ style: Int = 1) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttribute(.strikethroughStyle, value: style, range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }

    /// Appends an attributed string with a second one. Convenience method with need of conversion to NSMutableAttributedString.
    /// - Parameter string: attributed string that you wish to append.
    /// - Returns: a combination of two attributed strings.
    func appendAttributedString(_ string: NSAttributedString) -> NSAttributedString {
        let attributedString1 = NSMutableAttributedString(attributedString: self)
        let attributedString2 = NSMutableAttributedString(attributedString: string)
        attributedString1.append(attributedString2)
        return attributedString1
    }
}
