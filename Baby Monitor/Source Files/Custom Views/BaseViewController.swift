//
//  BaseViewController.swift
//  Baby Monitor
//

import UIKit

/// This class should be used in case of creating new view controller class.
/// For now it is only for not writing `required init?(coder aDecoder: NSCoder)`.
/// In the future it will probably have more features.
class BaseViewController: UIViewController {

    let analyticsManager: AnalyticsManager

    let analyticsScreenType: AnalyticsScreenType

    var className: String {
        return String(describing: type(of: self))
    }

    init(analyticsManager: AnalyticsManager, analyticsScreenType: AnalyticsScreenType) {
        self.analyticsManager = analyticsManager
        self.analyticsScreenType = analyticsScreenType
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.logScreen(analyticsScreenType, className: className)
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
