//
//  StreamFactoryMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class StreamFactoryMock: StreamFactoryProtocol {

    private let id: String

    init(id: String = UUID().uuidString) {
        self.id = id
    }

    func createStream() -> MediaStreamProtocol {
        return MediaStreamMock(id: id)
    }
}
