//
//  BasePageViewController.swift
//  Baby Monitor
//

import UIKit

class BasePageViewController: UIPageViewController {

    var className: String {
        return String(describing: type(of: self))
    }

    private let analytics: AnalyticsManager

    private let analyticsScreenType: AnalyticsScreenType
    
    init(analytics: AnalyticsManager, analyticsScreenType: AnalyticsScreenType) {
        self.analytics = analytics
        self.analyticsScreenType = analyticsScreenType
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analytics.logScreen(analyticsScreenType, className: className)
    }
}
