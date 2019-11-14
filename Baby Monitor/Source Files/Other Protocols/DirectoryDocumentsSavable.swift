//
//  DirectoryDocumentsSavable.swift
//  Baby Monitor
//

import Foundation
import AudioKit

protocol DirectoryDocumentsSavable {
    func save(withName name: String, completion: @escaping (Result<()>) -> Void)
}

extension AKAudioFile: DirectoryDocumentsSavable {
    func save(withName name: String, completion: @escaping (Result<()>) -> Void) {
        createCryingRecordsFolderIfNeeded()
        do {
            try FileManager.default.moveItem(at: avAsset.url, to: FileManager.cryingRecordsURL.appendingPathComponent(name))
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func createCryingRecordsFolderIfNeeded() {
        let folderPath = FileManager.cryingRecordsURL
        if !FileManager.default.fileExists(atPath: folderPath.path) {
                try? FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
