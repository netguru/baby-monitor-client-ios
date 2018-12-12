//
//  OnboardingContinuableViewModel.swift
//  Baby Monitor
//

import Foundation

final class OnboardingContinuableViewModel {
    
    var onSelectNext: (() -> Void)?
    
    func selectNext() {
        onSelectNext?()
    }
}
