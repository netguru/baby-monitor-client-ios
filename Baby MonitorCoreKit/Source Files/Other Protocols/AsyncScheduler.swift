//
//  AsyncScheduler.swift
//  Baby Monitor
//

import Foundation

protocol AsyncScheduler {
    func scheduleAsync(block: @escaping () -> Void)
}

extension DispatchQueue: AsyncScheduler {
    func scheduleAsync(block: @escaping () -> Void) {
        async(execute: block)
    }
}
