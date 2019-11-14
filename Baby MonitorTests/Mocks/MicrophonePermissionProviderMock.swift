//
//  MicrophonePermissionProviderMock.swift
//  Baby MonitorTests
//

import Foundation
import RxSwift
@testable import BabyMonitor

final class MicrophonePermissionProviderMock: MicrophonePermissionProviderProtocol {
    
    func getMicrophonePermission() -> Observable<Void> {
        return Observable.just(())
    }
}
