//
//  FileManager+DocumentsDirectories.swift
//  Baby Monitor
//

import Foundation

extension FileManager {
    
    static var cryingRecordsURL: URL {
        return documentsDirectoryURL.appendingPathComponent("cryingRecords", isDirectory: true)
    }
    
    static var documentsDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static var documentsDirectorySize: UInt64? {
        return try? `default`.allocatedSizeOfDirectory(at: documentsDirectoryURL)
    }
}
