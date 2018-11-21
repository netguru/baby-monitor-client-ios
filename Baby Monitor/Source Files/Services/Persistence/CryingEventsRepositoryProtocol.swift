//
//  CryingEventsRepositoryProtocol.swift
//  Baby Monitor
//

import Foundation

protocol CryingEventsRepositoryProtocol: Any {
    
/// Persists crying event in repository for current baby
///
/// - Parameter cryingEvent: object to persist
func save(cryingEvent: CryingEvent)

/// Returns all persisted crying events
///
/// - Returns: Crying events currently persisted in repository
func fetchAllCryingEvents() -> [CryingEvent]

/// Removes crying event from realm database
///
/// - Parameter cryingEvent: crying event to remove
func remove(cryingEvent: CryingEvent)
}
