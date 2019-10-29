//
//  AsyncSchedulerMock.swift
//  Baby MonitorTests
//


@testable import BabyMonitor

final class AsyncSchedulerMock: AsyncScheduler {
    func scheduleAsync(block: @escaping () -> Void) {
        block()
    }
}
