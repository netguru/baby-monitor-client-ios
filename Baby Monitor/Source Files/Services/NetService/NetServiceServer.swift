//
//  NetServiceServer.swift
//  Baby Monitor
//

import Foundation
import RxCocoa
import RxSwift

protocol NetServiceServerProtocol {

    /// The variable controlling the state of the server. Changing its
    /// underlying `value` to `true` enables the server and changing it to
    /// `false` disables it.
    var isEnabled: Variable<Bool> { get }
}

final class NetServiceServer: NSObject, NetServiceServerProtocol, NetServiceDelegate {

    private enum ServiceError: Error {
        case didNotPublish
    }

    let isEnabled = Variable<Bool>(false)

    private lazy var netService: NetService = NetService(
        domain: Constants.domain,
        type: Constants.netServiceType,
        name: Constants.netServiceName,
        port: Int32(Constants.iosWebsocketPort)
    )

    private let appStateProvider: ApplicationStateProvider
    private let errorLogger: ServerErrorLogger
    private let disposeBag = DisposeBag()

    init(appStateProvider: ApplicationStateProvider, serverErrorLogger: ServerErrorLogger) {
        self.appStateProvider = appStateProvider
        self.errorLogger = serverErrorLogger
        super.init()
        setupRx()
    }

    private func setupRx() {

        isEnabled.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] in $0 ? self.start() : self.stop() })
            .disposed(by: disposeBag)

        // iOS kills Bonjour broadcast when application enters the background
        // and then doesn't restart it when it returns to foreground. The server
        // needs to keep track of application state in order to explicitly
        // control the broadcast and ensure it's running always when possible.

        appStateProvider.willEnterBackground
            .filter { [unowned self] in self.isEnabled.value }
            .subscribe(onNext: { [unowned self] in self.stop() })
            .disposed(by: disposeBag)

        appStateProvider.willReenterForeground
            .filter { [unowned self] in self.isEnabled.value }
            .subscribe(onNext: { [unowned self] in self.start() })
            .disposed(by: disposeBag)

    }

    private func start() {
        netService.delegate = self
        netService.publish()
    }

    private func stop() {
        netService.stop()
    }

    func netService(_ sender: NetService, didNotPublish errorDict: [String: NSNumber]) {
        errorLogger.log(error: ServiceError.didNotPublish, additionalInfo: errorDict)
    }

}
