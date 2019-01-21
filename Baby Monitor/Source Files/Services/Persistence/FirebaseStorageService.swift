//
//  FirebaseStorageService.swift
//  Baby Monitor
//

import Foundation
import FirebaseStorage

protocol StorageServerServiceProtocol: AnyObject {
    func uploadRecordingsToDatabase()
    func uploadRecordingsToDatabaseIfNeeded()
}

final class FirebaseStorageService: StorageServerServiceProtocol {
    private var filepathsToSend: [URL] = []
    private var isSending = false
    private lazy var storageReference = Storage.storage().reference()
    private let shouldSendRecordingsKey = "SHOULD_SEND_RECORDINGS"
    private let userDefaults = UserDefaults.standard
    private let memoryCleaner: MemoryCleanerProtocol
    
    init(memoryCleaner: MemoryCleanerProtocol) {
        self.memoryCleaner = memoryCleaner
    }
    
    func uploadRecordingsToDatabase() {
        guard !isSending else {
            return
        }
        let filePaths = getAllFilepaths()
        filepathsToSend.append(contentsOf: filePaths)
        sendNextRecord { [unowned self] result in
            self.sendCompletionHandler(result: result)
        }
    }
    
    func uploadRecordingsToDatabaseIfNeeded() {
        let shouldSendRecords = userDefaults.bool(forKey: shouldSendRecordingsKey)
        guard shouldSendRecords else {
            return
        }
        uploadRecordingsToDatabase()
    }
    
    private func getAllFilepaths() -> [URL] {
        guard let enumerator = FileManager.default.enumerator(atPath: FileManager.cryingRecordsURL.path) else {
            return []
        }
        let fileUrls = enumerator.allObjects.compactMap({ $0 as? URL })
        return fileUrls
    }
    
    private func sendCompletionHandler(result: Result<URL>) {
        switch result {
        case .success(let filePath):
            memoryCleaner.removeFile(path: filePath)
            sendNextRecord { [unowned self] result in
                self.sendCompletionHandler(result: result)
            }
        case .failure:
            userDefaults.set(true, forKey: shouldSendRecordingsKey)
            filepathsToSend = []
        }
    }
    
    private func sendNextRecord(completion: @escaping (Result<URL>) -> Void) {
        guard !filepathsToSend.isEmpty else {
            self.userDefaults.set(false, forKey: self.shouldSendRecordingsKey)
            isSending = false
            return
        }
        isSending = true
        let filePath = filepathsToSend.removeFirst()
        let filePathString = filePath.absoluteString
        guard let fileName = filePathString.nameOfFileInPath() else {
            completion(.success(filePath))
            return
        }
        let recordingPath = storageReference.child(fileName)
        recordingPath.putFile(from: filePath, metadata: nil) { [unowned self] _, error in
            guard error != nil else {
                self.isSending = false
                completion(.failure(nil))
                return
            }
            completion(.success(filePath))
        }
    }
}
