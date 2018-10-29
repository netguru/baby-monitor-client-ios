//
//  BabyMonitorCellMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class BabyMonitorCellMock: BabyMonitorCellProtocol {
    
    var didTap: (() -> Void)?
    
    var type: BabyMonitorCell.`Type` = .activityLog
    
    private(set) var mainText: String?
    private(set) var secondaryText: String?
    private(set) var image: UIImage?
    private(set) var isConfiguredAsHeader = false
    
    func update(mainText: String) {
        self.mainText = mainText
    }
    
    func update(secondaryText: String) {
        self.secondaryText = secondaryText
    }
    
    func update(image: UIImage) {
        self.image = image
    }
    
    func configureAsHeader() {
        self.isConfiguredAsHeader = true
    }
}
