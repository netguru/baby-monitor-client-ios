//
//  MemoryCleaner.swift
//  Baby Monitor
//

import Foundation

protocol MemoryCleanerProtocol: Any {
    func cleanMemoryIfNeeded()
}

final class MemoryCleaner: MemoryCleanerProtocol {
    
    private let cryingEventsRepository: CryingEventsRepositoryProtocol
    
    init(cryingEventsRepository: CryingEventsRepositoryProtocol) {
        self.cryingEventsRepository = cryingEventsRepository
    }
    
    func cleanMemoryIfNeeded() {
        let twoHundredMB = 209715200
        guard let memoryUsage = FileManager.documentsDirectorySize,
            memoryUsage < twoHundredMB else {
                return
        }
        let allCryingEvents = cryingEventsRepository.fetchAllCryingEvents()
        var sortedCryingEvents = allCryingEvents.sorted { $0.date > $1.date }
        while (FileManager.documentsDirectorySize ?? 0) > UInt64(Double(twoHundredMB) * 0.7) {
            let cryingEventToRemove = sortedCryingEvents.remove(at: 0)
            if let _ = try? FileManager.default.removeItem(at: cryingEventToRemove.fileURL) {
                cryingEventsRepository.remove(cryingEvent: cryingEventToRemove)
            }
        }
    }
}
