//
//  IntroCoordinator.swift
//  Baby Monitor
//

import UIKit

final class IntroCoordinator: Coordinator {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var onEnding: (() -> Void)?
    private weak var introViewController: IntroViewController?

    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    func start() {
        showFeatures()
    }
    
    private func showFeatures() {
        let viewModelA = IntroViewModel()
        let viewModelB = IntroViewModel()
        
        var featureControllers: [IntroFeatureViewController] = []
        for (viewModel, feature) in zip([viewModelA, viewModelB], IntroFeature.allCases) {
            let featureController = IntroFeatureViewController(viewModel: viewModel, role: feature)
            featureControllers.append(featureController)
        }

        let introViewController = IntroViewController(featureControllers: featureControllers)
        self.introViewController = introViewController
        setFeatureViewController(featureControllers.first!)
        
        viewModelA.didSelectRightAction = { [weak self] in
            self?.setFeatureViewController(featureControllers[1])
            self?.introViewController?.updatePageControl(to: 1)
        }
        viewModelA.didSelectLeftAction = { [weak self] in
            self?.onEnding?()
        }
        viewModelB.didSelectRightAction = { [weak self] in
            self?.onEnding?()
        }
        
        navigationController.pushViewController(introViewController, animated: true)
    }
    
    private func setFeatureViewController(_ featureViewController: IntroFeatureViewController) {
        introViewController?.setViewControllers([featureViewController], direction: .forward, animated: true, completion: nil)
    }
}
