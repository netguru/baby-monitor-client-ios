//
//  NetServiceServer.swift
//  Baby Monitor
//

import Foundation
import RxCocoa
import RxSwift

protocol NetServiceServerProtocol {
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
