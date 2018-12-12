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
    
}
