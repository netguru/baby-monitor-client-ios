//
//  BaseView.swift
//  Baby Monitor
//

import UIKit

/// This class should be used in case of creating new view class.
/// For now it is only for not writing `required init?(coder aDecoder: NSCoder)`.
class BaseView: UIView {
    
    init() {
        super.init(frame: UIScreen.main.bounds)
    }
    
    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
