//
//  DateFormatter+Helpers.swift
//  Baby Monitor
//

import Foundation

extension DateFormatter {
    
    static func fullTimeFormatString(breakCharacter char: Character = Character(":")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY\(char)MM\(char)dd\(char)HH\(char)mm\(char)ss"
        return dateFormatter.string(from: Date())
    }
}
