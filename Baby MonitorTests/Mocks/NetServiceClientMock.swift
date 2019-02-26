//
//  NetClientMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift
import RxCocoa

final class NetServiceClientMock: NetServiceClientProtocol {

    let serviceRelay = PublishRelay<NetServiceDescriptor?>()
    let isEnabled = Variable<Bool>(false)

    var service: Observable<NetServiceDescriptor?> {
        let relay = Observable.combineLatest(serviceRelay, isEnabled.asObservable()).filter { _, enabled in enabled == true }.map { service, _ in service }
        let disabled = isEnabled.asObservable().filter { $0 == false }.map { _ in NetServiceDescriptor?.none }
        return Observable.merge(relay, disabled)
    }

}
