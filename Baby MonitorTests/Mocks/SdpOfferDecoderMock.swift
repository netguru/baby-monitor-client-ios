//
//  SdpOfferDecoderMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class SdpOfferDecoderMock: MessageDecoderProtocol {
    typealias T = WebRtcMessage

    private let sdpOffer: SessionDescriptionProtocol

    init(sdpOffer: SessionDescriptionProtocol) {
        self.sdpOffer = sdpOffer
    }

    func decode(message: String) -> WebRtcMessage? {
        return .sdpOffer(sdpOffer)
    }
}
