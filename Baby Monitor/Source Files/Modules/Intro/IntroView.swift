//
//  IntroView.swift
//  Baby Monitor
//

import UIKit

final class IntroView: BaseView {
    
    private enum Constants {
        static let buttonHeight: CGFloat = 50
        static let mainOffset: CGFloat = 20
        static let textAlpha: CGFloat = 0.7
    }
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    init(numberOfPages: Int) {
        super.init()
        setup(numberOfPages: numberOfPages)
    }
    
    func updatePageControl(to index: Int) {
        pageControl.currentPage = index
    }
    
    private func setup(numberOfPages: Int) {
        setupBackgroundImage(UIImage(named: "base-background"))
        pageControl.numberOfPages = numberOfPages
        addSubview(pageControl)
        setupConstraints()
    }
    
    private func setupConstraints() {
        pageControl.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.safeAreaBottom, constant: -97)
        ]
        }
    }
}
