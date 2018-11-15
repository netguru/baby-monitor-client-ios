//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//

import RxSwift

final class CameraPreviewViewModel {

    private let babyRepo: BabiesRepositoryProtocol
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
//<<<<<<< HEAD
    private let webRtcClientManager: WebRtcClientManagerProtocol
    var remoteStream: Observable<MediaStreamProtocol> {
        return webRtcClientManager.mediaStream
    }

    init(webRtcClientManager: WebRtcClientManagerProtocol, babyRepo: BabiesRepositoryProtocol) {
        self.webRtcClientManager = webRtcClientManager
        self.babyRepo = babyRepo
//=======
//    private let webRtcClientManager: WebrtcClientManager
//    private let webSocket: WebSocketProtocol?
//    private let decoders: [AnyMessageDecoder<WebRtcMessage>]
//    private let bag = DisposeBag()
//    var didLoadRemoteStream: ((RTCMediaStream) -> Void)?
//
//    init(webRtcClientManager: WebrtcClientManager, webSocket: WebSocketProtocol?, babyRepo: BabiesRepositoryProtocol, decoders: [AnyMessageDecoder<WebRtcMessage>]) {
//        self.webRtcClientManager = webRtcClientManager
//        self.webSocket = webSocket
//        self.babyRepo = babyRepo
//        self.decoders = decoders
//        webRtcClientManager.delegate = self
//        setup()
//    }
//
//    deinit {
//        webRtcClientManager.disconnect()
//        webSocket?.close()
//>>>>>>> d2863fb... Replaced RTSP with WebRTC
    }
    
    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectCancel: (() -> Void)?
<<<<<<< HEAD
=======

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
>>>>>>> d2863fb... Replaced RTSP with WebRTC
    
    // MARK: - Internal functions
    func selectCancel() {
        didSelectCancel?()
    }

<<<<<<< HEAD
=======
    func play() {
        webSocket?.open()
        webRtcClientManager.startWebrtcConnection()
    }

>>>>>>> d2863fb... Replaced RTSP with WebRTC
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
