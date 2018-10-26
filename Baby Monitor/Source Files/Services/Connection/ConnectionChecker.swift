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
    
    /// Called every time connection checker updates information about connection status
    var didUpdateStatus: ((ConnectionStatus) -> Void)? { get set }
    
    var connectionStatus: Observable<ConnectionStatus> { get }
    
    /// Starts connection checking
    func start()
    
    /// Stops connection checking
    func stop()
}
