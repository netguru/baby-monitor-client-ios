//
//  IntroViewModel.swift
//  Baby Monitor
//

import Foundation

enum IntroFeature: Int, CaseIterable {
    case monitoring, detection, safety, recordings
}

final class IntroViewModel {

    // MARK: - Coordinator callback
    /// Performed when the user taps a left button at the bottom of the view
    var didSelectLeftAction: (() -> Void)?

    /// Performed when the user taps a right button at the bottom of the view
    var didSelectRightAction: (() -> Void)?
    
    func selectLeftAction() {
        didSelectLeftAction?()
    }

    func selectRightAction() {
        didSelectRightAction?()
    }
}
