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
        let analyticsManager = appDependencies.analyticsManager
        let viewModels = [IntroViewModel(analyticsManager: analyticsManager),
                          IntroViewModel(analyticsManager: analyticsManager),
                          IntroViewModel(analyticsManager: analyticsManager)]
        var featureControllers: [IntroFeatureViewController] = []
        for (viewModel, feature) in zip(viewModels, IntroFeature.allCases) {
            let featureController = IntroFeatureViewController(viewModel: viewModel, role: feature)
            featureControllers.append(featureController)
        }

        let introViewController = IntroViewController(featureControllers: featureControllers)
        self.introViewController = introViewController
        setFeatureViewController(featureControllers.first!)

        for (i, viewModel) in viewModels.enumerated() {
            let isLast = (i == viewModels.count - 1)
            viewModel.didSelectRightAction = { [weak self] in
                if isLast {
                    self?.onEnding?()
                } else {
                    self?.setFeatureViewController(featureControllers[i + 1])
                    self?.introViewController?.updatePageControl(to: i + 1)
                }
            }
            viewModel.didSelectLeftAction = { [weak self] in
                self?.onEnding?()
            }
        }
        navigationController.setViewControllers([introViewController], animated: true)
    }
    
    private func setFeatureViewController(_ featureViewController: IntroFeatureViewController) {
        introViewController?.setViewControllers([featureViewController], direction: .forward, animated: true, completion: nil)
    }
}
