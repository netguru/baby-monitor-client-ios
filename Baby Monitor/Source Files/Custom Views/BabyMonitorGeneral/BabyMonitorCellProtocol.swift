//
//  BabyMonitorCellProtocol.swift
//  Baby Monitor
//

enum BabyMonitorCellType {
    case switchBaby(BabyMonitorSwitchBabyCellType)
    case lullaby
    case activityLog
    case settings
}

enum BabyMonitorSwitchBabyCellType {
    case baby
    case addAnother
}

protocol BabyMonitorCellProtocol: AnyObject {
    
    /// Delegate for cell tap
    var didTap: (() -> Void)? { get set }
    
    /// Cell type
    var type: BabyMonitorCellType { get set }
    
    /// Updates main text
    func update(mainText: String)
    
    /// Updates secondary text
    func update(secondaryText: String)
    
    /// Updates main image
    func update(image: UIImage)
    
    /// Updates selected state
    func showCheckmark(_ showing: Bool)
    
    /// Configures cell to look like a header
    func configureAsHeader()
}
