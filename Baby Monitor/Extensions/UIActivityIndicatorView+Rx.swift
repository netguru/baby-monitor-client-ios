//
//  UIActivityIndicatorView+Rx.swift
//  Baby Monitor
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base == UIActivityIndicatorView {
    var isLoading: Binder<Bool> {
        return Binder(base, binding: { indicator, isLoading in
            if isLoading {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        })
    }
}
