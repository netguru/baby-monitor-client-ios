//
//  UIViewController+Rx.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    /// Reactive wrapper for `viewDidLoad` message `UIViewController:viewDidLoad:`.
    public var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `viewDidAppear` message `UIViewController:viewDidLoad:`.
    public var viewDidAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `viewDidDisappear` message `UIViewController:viewDidLoad:`.
    public var viewDidDisappear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
