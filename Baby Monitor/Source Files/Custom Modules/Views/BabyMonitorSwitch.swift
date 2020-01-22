//
//  BabyMonitorSwitch.swift
//  Baby Monitor
//

import UIKit

final class BabyMonitorSwitch: UISwitch {
    
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 16
        onTintColor = .babyMonitorPurple
        tintColor = UIColor.white
        backgroundColor = UIColor.babyMonitorDarkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
