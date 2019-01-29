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
        pageControl.numberOfPages = IntroFeature.allCases.count
        return pageControl
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    func updatePageControl(to index: Int) {
        pageControl.currentPage = index
    }
    
    private func setup() {
        setupBackgroundImage(UIImage(named: "base-background"))
        addSubview(pageControl)
        setupConstraints()
    }
    
    private func setupConstraints() {
        pageControl.addConstraints {[
            $0.equal(.centerX),
            $0.equal(.safeAreaBottom, constant: -100)
        ]
        }
    }
}
