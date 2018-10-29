//
//  ConnectionChecker.swift
//  Baby Monitor
//

import RxSwift

enum ConnectionStatus {
    case connected
    case disconnected
}

protocol ConnectionChecker: AnyObject {
    
    /// Observable emitting connection status changes
    var connectionStatus: Observable<ConnectionStatus> { get }
    
    /// Starts connection checking
    func start()
    
    /// Stops connection checking
    func stop()
}
