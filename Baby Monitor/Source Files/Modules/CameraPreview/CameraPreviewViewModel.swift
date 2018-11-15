//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift
import WebRTC

final class CameraPreviewViewModel {

    private let babyRepo: BabiesRepositoryProtocol
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
    private let webRtcClientManager: WebrtcClientManager
    private let webSocket: WebSocketProtocol?
    private let decoders: [AnyMessageDecoder<WebRtcMessage>]
    private let bag = DisposeBag()
    var didLoadRemoteStream: ((RTCMediaStream) -> Void)?

    init(webRtcClientManager: WebrtcClientManager, webSocket: WebSocketProtocol?, babyRepo: BabiesRepositoryProtocol, decoders: [AnyMessageDecoder<WebRtcMessage>]) {
        self.webRtcClientManager = webRtcClientManager
        self.webSocket = webSocket
        self.babyRepo = babyRepo
        self.decoders = decoders
        webRtcClientManager.delegate = self
        setup()
    }

    deinit {
        webRtcClientManager.disconnect()
        webSocket?.close()
    }

    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectCancel: (() -> Void)?

    private func setup() {
        webSocket?.decodedMessage(using: decoders)
            .subscribe(onNext: { [unowned self] message in
                guard let message = message else {
                    return
                }
                self.handle(message: message)
            })
            .disposed(by: bag)
    }
    
    private func handle(message: WebRtcMessage) {
        switch message {
        case .sdpAnswer(let sdp):
            webRtcClientManager.setAnswerSDP(sdp: sdp)
        case .iceCandidate(let candidate):
            webRtcClientManager.setICECandidates(iceCandidate: candidate)
        default:
            break
        }
    }
    
    // MARK: - Internal functions
    func selectCancel() {
        didSelectCancel?()
    }

    func play() {
        webSocket?.open()
        webRtcClientManager.startWebrtcConnection()
    }

    func selectShowBabies() {
        didSelectShowBabies?()
    }
}

extension CameraPreviewViewModel: WebrtcClientManagerDelegate {
    func offerSDPCreated(sdp: RTCSessionDescription) {
        let json = [WebRtcMessage.Key.offerSDP.rawValue: sdp.jsonDictionary()]
        guard let jsonString = json.jsonString else {
            return
        }
        webSocket?.send(message: jsonString)
    }
    
    func remoteStreamAvailable(stream: RTCMediaStream) {
        didLoadRemoteStream?(stream)
    }
    
    func iceCandidatesCreated(iceCandidate: RTCICECandidate) {
        let json = [WebRtcMessage.Key.iceCandidate.rawValue: iceCandidate.jsonDictionary()]
        guard let jsonString = json.jsonString else {
            return
        }
        webSocket?.send(message: jsonString)
    }
    
    func dataReceivedInChannel(data: NSData) {}
}
