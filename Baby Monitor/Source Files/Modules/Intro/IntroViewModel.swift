//
//  IntroViewModel.swift
//  Baby Monitor
//

import Foundation

enum IntroFeature: Int, CaseIterable {
    case monitoring, detection, safety
}

final class IntroViewModel {
    
    // MARK: - Coordinator callback
    /// Indicates that user has tapped a left button at the bottom of the view
    var didSelectLeftAction: (() -> Void)?

    /// Indicates that user has tapped a right button at the bottom of the view
    var didSelectRightAction: (() -> Void)?

    func selectLeftAction() {
        didSelectLeftAction?()
    }

    func selectRightAction() {
        didSelectRightAction?()
    }
}
