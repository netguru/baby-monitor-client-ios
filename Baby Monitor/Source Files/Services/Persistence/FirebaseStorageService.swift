//
//  FirebaseStorageService.swift
//  Baby Monitor
//

import Foundation
import FirebaseStorage

protocol StorageServerServiceProtocol: AnyObject {
    func uploadRecordingsToDatabaseIfAllowed()
}

final class FirebaseStorageService: StorageServerServiceProtocol {
    private var subpathsToSend: Set<String> = []
    private var isSending = false
    private lazy var storageReference = Storage.storage().reference()
    private let userDefaults = UserDefaults.standard
    private let memoryCleaner: MemoryCleanerProtocol
    
    init(memoryCleaner: MemoryCleanerProtocol) {
        self.memoryCleaner = memoryCleaner
    }
    
    func uploadRecordingsToDatabaseIfAllowed() {
        guard UserDefaults.isSendingCryingsAllowed else {
            return
        }
        subpathsToSend = subpathsToSend.union(getAllSubpaths())
        guard !isSending else {
            return
        }
        sendNextRecord { [unowned self] result in
            self.sendCompletionHandler(result: result)
        }
    }
    
    private func getAllSubpaths() -> [String] {
        let cryingRecordsUrl = FileManager.cryingRecordsURL
        guard let subpaths = FileManager.default.subpaths(atPath: cryingRecordsUrl.path) else {
            return []
        }
        return subpaths
    }
    
    private func sendCompletionHandler(result: Result<URL>) {
        switch result {
        case .success(let filePath):
            memoryCleaner.removeFile(path: filePath)
            sendNextRecord { [unowned self] result in
                self.sendCompletionHandler(result: result)
            }
        case .failure:
            subpathsToSend = []
        }
    }
    
    private func sendNextRecord(completion: @escaping (Result<URL>) -> Void) {
        guard !subpathsToSend.isEmpty else {
            isSending = false
            return
        }
        isSending = true
        let subpath = subpathsToSend.removeFirst()
        let fileUrl = FileManager.cryingRecordsURL.appendingPathComponent(subpath).absoluteString.url!
        let recordingPath = storageReference.child(subpath)
        recordingPath.putFile(from: fileUrl, metadata: nil) { [unowned self] _, error in
            guard error == nil else {
                self.isSending = false
                completion(.failure(nil))
                return
            }
            completion(.success(fileUrl))
        }
    }
}
