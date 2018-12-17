//
//  UDPeerToPeerService.swift
//  Baby Monitor
//


import Foundation
import Underdark
import RxSwift

protocol PeerToPeerServiceProtocol: AnyObject, ErrorProducable {
    func start()
    func stop()
    func send(message: String)
}

final class UDPeerToPeerService: NSObject, PeerToPeerServiceProtocol {
    
    enum PeerToPeerServiceError: Error {
        case unknownMessage
        case notConnected
        case onDisconnect
    }
    
    lazy var errorObservable = errorPublisher.asObservable()
    lazy var messageObservable = messagePublisher.asObservable()
    
    private let errorPublisher = PublishSubject<Error>()
    private let messagePublisher = PublishSubject<String>()
    private let appId: Int32 = 234235
    private let nodeId: Int64
    private var transport: UDTransport
    private var connectedPeer: UDLink? {
        didSet {
            if connectedPeer == nil {
                errorPublisher.onNext(PeerToPeerServiceError.onDisconnect)
            }
        }
    }
    
    override init() {
        var buf: Int64 = 0
        repeat {
            arc4random_buf(&buf, MemoryLayout.size(ofValue: buf))
            //TODO: check it
        } while buf == 0
        if(buf < 0) {
            buf = -buf;
        }
        nodeId = buf;
        let transportKinds = [UDTransportKind.wifi.rawValue]
        transport = UDUnderdark.configureTransport(withAppId: appId, nodeId: nodeId, queue: DispatchQueue.main, kinds: transportKinds)
        super.init()
        
        transport.delegate = self
    }
    
    func start() {
        transport.start()
    }
    
    func stop() {
        transport.stop()
    }
    
    func send(message: String) {
        guard let connectedPeer = connectedPeer else {
            errorPublisher.onNext(PeerToPeerServiceError.notConnected)
            return
        }
        let messageData = Data(base64Encoded: message)!
        connectedPeer.sendFrame(messageData)
    }
}

//MARK: - UDTransportDelegate
extension UDPeerToPeerService: UDTransportDelegate {
    
    func transport(_ transport: UDTransport, linkConnected link: UDLink) {
        if let _ = connectedPeer {
            link.disconnect()
        } else {
           connectedPeer = link
        }
    }
    
    func transport(_ transport: UDTransport, linkDisconnected link: UDLink) {
        guard let connectedPeer = connectedPeer else {
            return
        }
        
        if link.nodeId == connectedPeer.nodeId {
            self.connectedPeer = nil
        }
    }
    
    func transport(_ transport: UDTransport, link: UDLink, didReceiveFrame frameData: Data) {
        guard
            let peer = self.connectedPeer,
            link.nodeId == peer.nodeId
        else {
            errorPublisher.onNext(PeerToPeerServiceError.notConnected)
            return
        }
        let messageString = String(data: frameData, encoding: .utf8)!
        messagePublisher.onNext(messageString)
    }
}
