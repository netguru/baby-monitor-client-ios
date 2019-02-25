//
//  NetServiceClient.swift
//  Baby Monitor
//

import Foundation
import RxCocoa
import RxSwift

protocol NetServiceClientProtocol: AnyObject {
    var service: Observable<(ip: String, port: String)?> { get }
    var isEnabled: Variable<Bool> { get }
}

final class NetServiceClient: NSObject, NetServiceClientProtocol {

    let isEnabled = Variable<Bool>(false)

    lazy var service = serviceVariable.asObservable()
    private let serviceVariable = Variable<(ip: String, port: String)?>(nil)

    private var netService: NetService?
    private let netServiceBrowser = NetServiceBrowser()
    private let netServiceAllowedPorts = [Constants.androidWebsocketPort, Constants.iosWebsocketPort]

    private let disposeBag = DisposeBag()

    override init() {
        super.init()
        setupRx()
    }

    private func setupRx() {
        isEnabled.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] in $0 ? self.start() : self.stop() })
            .disposed(by: disposeBag)
    }

    private func start() {
        netServiceBrowser.delegate = self
        netServiceBrowser.searchForServices(ofType: Constants.netServiceType, inDomain: Constants.domain)
    }

    private func stop() {
        netServiceBrowser.stop()
        serviceVariable.value = nil
        netService = nil
    }

    private func getIP(from data: Data) -> String? {
        return data.withUnsafeBytes { (pointer: UnsafePointer<sockaddr>) in
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(pointer, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                return String(cString: hostname)
            } else {
                return nil
            }
        }
    }

}

// MARK: - NetServiceBrowserDelegate
extension NetServiceClient: NetServiceBrowserDelegate {

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        netService = service
        netService!.delegate = self
        netService!.resolve(withTimeout: 5)
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        guard service === netService else { return }
        serviceVariable.value = nil
        netService = nil
    }

}

// MARK: - NetServiceDelegate
extension NetServiceClient: NetServiceDelegate {

    func netServiceDidResolveAddress(_ sender: NetService) {
        guard sender === netService else { return }
        guard let address = sender.addresses?.first else { return }
        guard netServiceAllowedPorts.contains(sender.port), let ip = getIP(from: address) else { return }
        serviceVariable.value = (ip: ip, port: String(sender.port))
    }

    public func netServiceDidStop(_ sender: NetService) {
        guard sender === netService else { return }
        serviceVariable.value = nil
        netService = nil
    }

}
