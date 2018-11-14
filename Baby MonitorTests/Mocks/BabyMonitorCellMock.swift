//
//  BabyMonitorCellMock.swift
//  Baby MonitorTests
//

@testable import BabyMonitor

final class BabyMonitorCellMock: BabyMonitorCellProtocol {
    
    var didTap: (() -> Void)?
    
    var type: BabyMonitorCellType = .activityLog
    
    private(set) var mainText: String?
    private(set) var secondaryText: String?
    private(set) var image: UIImage?
    private(set) var isConfiguredAsHeader = false
    private(set) var accessoryType: UITableViewCell.AccessoryType = .none
    
    func update(mainText: String) {
        self.mainText = mainText
    }
    
    func update(secondaryText: String) {
        self.secondaryText = secondaryText
    }
    
    func update(image: UIImage) {
        self.image = image
    }
    
    func showCheckmark(_ showing: Bool) {
        if showing {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
    
    func configureAsHeader() {
        self.isConfiguredAsHeader = true
    }
}
