//
//  BabiesViewShowable.swift
//  Baby Monitor
//

import UIKit

protocol BabiesViewShowable: AnyObject {
    
    var switchBabyViewController: BabyMonitorGeneralViewController? { get set }
    
    /// Adds/removes switchBabiesViewController to another view controller
    ///
    /// - Parameter viewController: view controller that will add switchBabyViewController if it wasn't added before
    func toggleSwitchBabiesView(on viewController: UIViewController, babyService: BabyServiceProtocol)
}

extension BabiesViewShowable {
    
    func toggleSwitchBabiesView(on viewController: UIViewController, babyService: BabyServiceProtocol) {
        if let switchBabyViewController = self.switchBabyViewController {
            switchBabyViewController.removeFromParentViewController()
            self.switchBabyViewController = nil
            return
        }
        
        let switchBabyViewModel = SwitchBabyViewModel(babyService: babyService)
        let switchBabyViewController = BabyMonitorGeneralViewController(viewModel: switchBabyViewModel, type: .switchBaby)
        self.switchBabyViewController = switchBabyViewController
        viewController.addChildViewController(switchBabyViewController)

    }
}
