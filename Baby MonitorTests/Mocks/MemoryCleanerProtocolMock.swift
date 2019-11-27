import Foundation

@testable import BabyMonitor

class MemoryCleanerMock: MemoryCleanerProtocol {
    
    private(set) var cleanMemoryIfNeededCalled: Bool = false
    private(set) var cleanMemoryCalled: Bool = false
    private(set) var lastRemovedFilePath: URL?
    
    func cleanMemoryIfNeeded() {
        cleanMemoryIfNeededCalled = true
    }
    
    func cleanMemory() {
        cleanMemoryCalled = true
    }
    
    func removeFile(path: URL) {
        lastRemovedFilePath = path
    }
}
