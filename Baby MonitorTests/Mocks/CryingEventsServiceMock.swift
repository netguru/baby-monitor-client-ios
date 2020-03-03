//
//  CryingEventsServiceMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift

final class CryingEventsServiceMock: CryingEventsServiceProtocol {

    private(set) var isStarted = false
    var cryingEventObservable: Observable<Void> {
        return cryingEventPublisher
    }
    var loggingInfoPublisher = PublishSubject<String>()
    let cryingEventPublisher = PublishSubject<Void>()
    private let shouldThrow: Bool

    init(shouldThrow: Bool = false) {
        self.shouldThrow = shouldThrow
    }

    func start() throws {
        if shouldThrow {
            throw SoundDetectionService.SoundDetectionServiceError.audioRecordServiceError
        }
        isStarted = true
    }

    func stop() {
        isStarted = false
    }
}
