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

    let isEnabled = Variable<Bool>(false)

    private lazy var netService: NetService = NetService(
        domain: Constants.domain,
        type: Constants.netServiceType,
        name: Constants.netServiceName,
        port: Int32(Constants.iosWebsocketPort)
    )

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

        // iOS kills Bonjour broadcast when application enters the background
        // and then doesn't restart it when it returns to foreground. The server
        // needs to keep track of application state in order to explicitly
        // control the broadcast and ensure it's running always when possible.

        NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification)
            .filter { [unowned self] _ in self.isEnabled.value }
            .subscribe(onNext: { [unowned self] _ in self.stop() })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .filter { [unowned self] _ in self.isEnabled.value }
            .subscribe(onNext: { [unowned self] _ in self.start() })
            .disposed(by: disposeBag)

    }

    private func start() {
        netService.delegate = self
        netService.publish()
    }

    private func stop() {
        netService.stop()
    }

}
