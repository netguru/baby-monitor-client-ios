//
//  ApplicationStateProviderMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import RxSwift
import RxCocoa

final class ApplicationStateProviderMock: ApplicationStateProvider {
    let willEnterBackground: Observable<Void> = PublishSubject<Void>()
    let willEnterForeground: Observable<Void> = PublishSubject<Void>()
    init() {}
}
