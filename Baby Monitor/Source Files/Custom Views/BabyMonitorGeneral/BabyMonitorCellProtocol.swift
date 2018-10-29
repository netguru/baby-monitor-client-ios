//
//  BabyMonitorCellProtocol.swift
//  Baby Monitor
//

protocol BabyMonitorCellProtocol: AnyObject {
    
    /// Delegate for cell tap
    var didTap: (() -> Void)? { get set }
    
    /// Cell type
    var type: BabyMonitorCell.`Type` { get set }
    
    /// Updates main text
    func update(mainText: String)
    
    /// Updates secondary text
    func update(secondaryText: String)
    
    /// Updates main image
    func update(image: UIImage)
    
    /// Configures cell to look like a header
    func configureAsHeader()
}
