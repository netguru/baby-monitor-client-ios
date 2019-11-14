//
//  ApplicationStateProviderMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift
import RxCocoa

final class ApplicationStateProviderMock: ApplicationStateProvider {
    let willEnterBackground: Observable<Void> = PublishSubject<Void>()
    let willReenterForeground: Observable<Void> = PublishSubject<Void>()
    init() {}
}
