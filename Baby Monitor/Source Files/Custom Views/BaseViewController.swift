//
//  BaseViewController.swift
//  Baby Monitor
//

import UIKit

/// This class should be used in case of creating new view controller class.
/// For now it is only for not writing `required init?(coder aDecoder: NSCoder)`.
/// In the future it will probably have more features.
class BaseViewController: UIViewController {

    /// A name of the view controller.
    var className: String {
        return String(describing: type(of: self))
    }

    private let analytics: AnalyticsManager?

    private let analyticsScreenType: AnalyticsScreenType?

    /// Initializes the view controller.
    /// - Parameters:
    ///     - analytics: Analytics manager for tracking screens appearance.
    ///     - analyticsScreenType: The type of the screen in terms of analytics tracking.
    init(analytics: AnalyticsManager?, analyticsScreenType: AnalyticsScreenType?) {
        self.analytics = analytics
        self.analyticsScreenType = analyticsScreenType
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let analytics = analytics, let screenType = analyticsScreenType else {
            Logger.warning("Analytics is not implemented for the screen \(className)")
            return
        }
        analytics.logScreen(screenType, className: className)
    }

    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
