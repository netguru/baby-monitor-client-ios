//
//  ApplicationStateProvider.swift
//  Baby Monitor
//

import Foundation
import RxSwift
import RxCocoa

protocol ApplicationStateProvider {
    var willEnterBackground: Observable<Void> { get }
    var willReenterForeground: Observable<Void> { get }
}

extension NotificationCenter: ApplicationStateProvider {

    var willEnterBackground: Observable<Void> {
        return rx.notification(UIApplication.willResignActiveNotification).map { _ in () }
    }

    var willReenterForeground: Observable<Void> {
        // Skip the first event, because it's triggered by the first entering of the app and this method provides event for RE-entering
        return rx.notification(UIApplication.didBecomeActiveNotification).map { _ in () }.skip(1)
    }

}
