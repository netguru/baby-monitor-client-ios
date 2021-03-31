//
//  MemoryCleaner.swift
//  Baby Monitor
//

import Foundation

protocol MemoryCleanerProtocol: AnyObject {
    func cleanMemoryIfNeeded()
    func cleanMemory()
    func removeFile(path: URL)
}

final class MemoryCleaner: MemoryCleanerProtocol {
    
    func cleanMemory() {
        guard let enumerator = FileManager.default.enumerator(atPath: FileManager.cryingRecordsURL.path) else {
                return
        }
        let fileUrls = enumerator.allObjects.compactMap({ $0 as? URL })
        fileUrls.forEach {
            removeFile(path: $0)
        }
    }
    
    func cleanMemoryIfNeeded() {
        let twoHundredMB = 200 * 1024 * 1024
        let cryingRecordsUrl = FileManager.cryingRecordsURL
        guard let subpaths = FileManager.default.subpaths(atPath: cryingRecordsUrl.path),
            let memoryUsage = FileManager.documentsDirectorySize,
            memoryUsage < twoHundredMB else {
                return
        }
        var fileUrls = subpaths.compactMap { cryingRecordsUrl.appendingPathComponent($0).absoluteString.url }
        while (FileManager.documentsDirectorySize ?? 0) > UInt64(Double(twoHundredMB) * 0.7) {
            guard !fileUrls.isEmpty else {
                break
            }
            let fileToRemoveUrl = fileUrls.remove(at: 0)
            removeFile(path: fileToRemoveUrl)
        }
    }
    
    func removeFile(path: URL) {
        try? FileManager.default.removeItem(at: path)
    }
}
