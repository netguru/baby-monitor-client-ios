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

    func createStream(didCreateStream: (MediaStreamProtocol, VideoCapturer) -> Void) {
        didCreateStream(MediaStreamMock(id: id), VideoCapturerMock())
    }
}
