//
//  Rx+Expectations.swift
//  Baby MonitorTests
//

import RxSwift
import XCTest

extension Observable {
    func fulfill(expectation: XCTestExpectation, afterEventCount eventCount: Int, bag: DisposeBag, handler: (() -> Void)? = nil) {
        self.scan(0, accumulator: { acc, _ in return acc + 1 })
            .filter { $0 == eventCount }
            .map { _ in () }
            .subscribe(onNext: { _ in
                handler?()
                expectation.fulfill()
            })
            .disposed(by: bag)
    }
}
