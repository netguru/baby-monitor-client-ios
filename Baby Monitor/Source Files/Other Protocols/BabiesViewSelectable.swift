//
//  BabiesViewSelectable.swift
//  Baby Monitor
//

import RxCocoa

protocol BabiesViewSelectable {
    
    /// Attaches taps on show babies button
    ///
    /// - Parameter showBabiesTap: Control event representing taps
    func attachInput(showBabiesTap: ControlEvent<Void>)
}
