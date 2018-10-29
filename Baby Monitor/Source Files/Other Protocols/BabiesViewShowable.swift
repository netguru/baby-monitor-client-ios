//
//  BabiesViewShowable.swift
//  Baby Monitor
//

import UIKit

protocol BabiesViewShowable: AnyObject {
    
    var switchBabyViewController: BabyMonitorGeneralViewController<SwitchBabyViewModel.Cell>? { get set }
    
    /// Adds/removes switchBabiesViewController to another view controller
    ///
    /// - Parameter viewController: view controller that will add switchBabyViewController if it wasn't added before
    func toggleSwitchBabiesView(on viewController: UIViewController, babyRepo: BabiesRepositoryProtocol)
}

extension BabiesViewShowable {
    
    func toggleSwitchBabiesView(on viewController: UIViewController, babyRepo: BabiesRepositoryProtocol) {
        if let switchBabyViewController = self.switchBabyViewController {
            switchBabyViewController.removeFromParentViewController()
            self.switchBabyViewController = nil
            return
        }
        
        let switchBabyViewModel = SwitchBabyViewModel(babyRepo: babyRepo)
        let switchBabyViewController = BabyMonitorGeneralViewController(viewModel: AnyBabyMonitorGeneralViewModelProtocol<SwitchBabyViewModel.Cell>(viewModel: switchBabyViewModel), type: .switchBaby)
        self.switchBabyViewController = switchBabyViewController
        viewController.addChildViewController(switchBabyViewController)

    }
}
