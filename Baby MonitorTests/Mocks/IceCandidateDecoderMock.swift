//
//  IceCandidateDecoderMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class IceCandidateDecoderMock: MessageDecoderProtocol {

    typealias T = WebRtcMessage

    private let iceCandidate: IceCandidateProtocol

    init(iceCandidate: IceCandidateProtocol) {
        self.iceCandidate = iceCandidate
    }

    func decode(message: String) -> WebRtcMessage? {
        return .iceCandidate(iceCandidate)
    }
}
