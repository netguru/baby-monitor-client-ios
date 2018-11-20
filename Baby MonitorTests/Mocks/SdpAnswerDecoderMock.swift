//
//  SdpAnswerDecoderMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class SdpAnswerDecoderMock: MessageDecoderProtocol {
    typealias T = WebRtcMessage

    private let sdpAnswer: SessionDescriptionProtocol

    init(sdpAnswer: SessionDescriptionProtocol) {
        self.sdpAnswer = sdpAnswer
    }

    func decode(message: String) -> WebRtcMessage? {
        return .sdpAnswer(sdpAnswer)
    }
}
