//
//  ApplicationStateProvider.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

protocol ApplicationStateProvider {
    var willEnterBackground: Observable<Void> { get }
    var willEnterForeground: Observable<Void> { get }
}

extension NotificationCenter: ApplicationStateProvider {

    var willEnterBackground: Observable<Void> {
        return rx.notification(UIApplication.willResignActiveNotification).map { _ in () }
    }

    var willEnterForeground: Observable<Void> {
        return rx.notification(UIApplication.willEnterForegroundNotification).map { _ in () }
    }

}
