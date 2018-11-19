//
//  FileManager+DocumentsDirectory.swift
//  Baby Monitor
//

import Foundation

extension FileManager {
    static var documentsDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static var documentsDirectorySize: UInt64? {
        return try? `default`.allocatedSizeOfDirectory(at: documentsDirectoryURL)
    }
}
