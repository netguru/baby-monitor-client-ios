//
//  NetClientMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift
import RxCocoa

final class NetServiceClientMock: NetServiceClientProtocol {

    let servicesRelay = PublishRelay<[NetServiceDescriptor]>()
    let isEnabled = Variable<Bool>(false)

    var services: Observable<[NetServiceDescriptor]> {
        let relay = Observable.combineLatest(servicesRelay, isEnabled.asObservable()).filter { _, enabled in enabled == true }.map { service, _ in service }
        let disabled: Observable<[NetServiceDescriptor]> = isEnabled.asObservable().filter { $0 == false }.map { _ in [] }
        return Observable.merge(relay, disabled)
    }

}
