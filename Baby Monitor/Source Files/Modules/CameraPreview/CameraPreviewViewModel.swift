//
//  CameraPreviewViewModel.swift
//  Baby Monitor
//


import Foundation

final class CameraPreviewViewModel {
    
    //MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectCancel: (() -> Void)?
    
    //MARK: - Internal functions
    func selectCancel() {
        didSelectCancel?()
    }
    
    func selectShowBabies() {
        didSelectShowBabies?()
    }
}
