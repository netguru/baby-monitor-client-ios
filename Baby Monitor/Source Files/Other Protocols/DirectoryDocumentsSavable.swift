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
        do {
            try FileManager.default.moveItem(at: avAsset.url, to: FileManager.cryingRecordsURL.appendingPathComponent(name).appendingPathExtension("caf"))
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
