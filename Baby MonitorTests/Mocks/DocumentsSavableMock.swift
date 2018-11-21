//
//  DocumentsSavableMock.swift
//  Baby MonitorTests
//

import Foundation
@testable import BabyMonitor

struct DocumentsSavableMock: DirectoryDocumentsSavable {
    
    private let isSaveSuccess: Bool
   
    init(isSaveSuccess: Bool) {
        self.isSaveSuccess = isSaveSuccess
    }
    
    func save(withName name: String, completion: @escaping (Result<()>) -> Void) {
        if isSaveSuccess {
            completion(.success(()))
        } else {
            completion(.failure(nil))
        }
    }
}
