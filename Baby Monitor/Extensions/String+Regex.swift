//
//  String+Regex.swift
//  Baby Monitor
//

import Foundation

extension String {
    
    func nameOfFileInPath() -> String? {
        let regex = try! NSRegularExpression(pattern: "/[^/]+$", options: .caseInsensitive)
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        guard
            let match = matches.first,
            let range = Range(match.range, in: self)
        else {
            return nil
        }
        var fileName = self[range]
        fileName.removeFirst()
        return String(fileName)
    }
}
