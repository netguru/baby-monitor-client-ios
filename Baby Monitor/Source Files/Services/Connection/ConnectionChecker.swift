//
//  ConnectionChecker.swift
//  Baby Monitor
//

enum ConnectionStatus {
    case connected
    case disconnected
}

protocol ConnectionChecker: AnyObject {
    
    /// Called every time connection checker updates information about connection status
    var didUpdateStatus: ((ConnectionStatus) -> Void)? { get set }
    
    /// Starts connection checking
    func start()
    
    /// Stops connection checking
    func stop()
}
