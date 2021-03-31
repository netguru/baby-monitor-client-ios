//
//  ActivityLogEventsRepositoryProtocol.swift
//  Baby Monitor
//

import Foundation
import RxSwift

protocol ActivityLogEventsRepositoryProtocol: Any {
    
    /// Activity log events observable
    var activityLogEventsObservable: Observable<[ActivityLogEvent]> { get }
    
    /// Persists activity log event in repository for current baby
    ///
    /// - Parameter cryingEvent: object to persist
    func save(activityLogEvent: ActivityLogEvent, completion: @escaping (Result<()>) -> Void)
    
    /// Returns all persisted activity log events
    ///
    /// - Returns: Crying events currently persisted in repository
    func fetchAllActivityLogEvents() -> [ActivityLogEvent]
}
