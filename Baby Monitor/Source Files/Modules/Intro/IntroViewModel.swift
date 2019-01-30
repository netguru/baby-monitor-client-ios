//
//  IntroViewModel.swift
//  Baby Monitor
//

import Foundation

enum IntroFeature: Int, CaseIterable {
    case featureDetection = 0
    case featureMonitoring
}

final class IntroViewModel {
    
    // MARK: - Coordinator callback
    var didSelectLeftAction: (() -> Void)?
    var didSelectRightAction: (() -> Void)?

    func selectLeftAction() {
        didSelectLeftAction?()
    }

    func selectRightAction() {
        didSelectRightAction?()
    }
}
