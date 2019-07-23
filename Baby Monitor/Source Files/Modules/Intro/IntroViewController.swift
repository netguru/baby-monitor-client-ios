//
//  IntroViewController.swift
//  Baby Monitor
//

import UIKit

class IntroViewController: TypedPageViewController<IntroView>, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var featureControllers: [UIViewController]
    private var pendingIndex = 0
    
    init(featureControllers: [UIViewController]) {
        self.featureControllers = featureControllers
        super.init(viewMaker: IntroView(numberOfPages: featureControllers.count))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func updatePageControl(to index: Int) {
        customView.updatePageControl(to: index)
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = featureControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0, featureControllers.count > previousIndex else {
            return nil
        }
        return featureControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = featureControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let featureControllersCount = featureControllers.count
        guard featureControllersCount != nextIndex, featureControllersCount > nextIndex else {
            return nil
        }
        return featureControllers[nextIndex]
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let pendingFeatureController = pendingViewControllers.first, let pendingIndex = featureControllers.firstIndex(of: pendingFeatureController) else {
            return
        }
        self.pendingIndex = pendingIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            updatePageControl(to: pendingIndex)
        }
    }
}
