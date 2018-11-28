//
//  IntroViewController.swift
//  Baby Monitor
//

import UIKit

class IntroViewController: TypedPageViewController<IntroView>, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var featureControllers: [UIViewController]
    private var pendingIndex: Int?
    
    init(featureControllers: [UIViewController]) {
        self.featureControllers = featureControllers
        super.init(viewMaker: IntroView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func updatePageControl(to index: Int) {
        customView.updatePageControl(to: index)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = featureControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard featureControllers.count > previousIndex else { return nil }
        return featureControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = featureControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        let featureControllersCount = featureControllers.count
        guard featureControllersCount != nextIndex else { return nil }
        guard featureControllersCount > nextIndex else { return nil }
        return featureControllers[nextIndex]
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = featureControllers.firstIndex(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let pendingIndex = pendingIndex {
            updatePageControl(to: pendingIndex)
        }
    }
}
