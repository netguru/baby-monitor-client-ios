//
//  OldOnboardingContinuableViewModel.swift
//  Baby Monitor
//

import Foundation

final class OldOnboardingContinuableViewModel {
    
    var onSelectNext: (() -> Void)?
    
    func selectNext() {
        onSelectNext?()
    }
}
