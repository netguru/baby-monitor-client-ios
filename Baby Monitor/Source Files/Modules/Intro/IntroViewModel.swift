//
//  IntroViewModel.swift
//  Baby Monitor
//

import Foundation

enum IntroFeature: Int, CaseIterable {
    case featureA = 0
    case featureB
}

final class IntroViewModel {
    
    // MARK: - Coordinator callback
    var didSelectNextAction: (() -> Void)?
    
    func selectNextAction() {
        didSelectNextAction?()
    }
}
