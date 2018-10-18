//
//  DashboardViewModel.swift
//  Baby Monitor
//


import Foundation

final class DashboardViewModel {
    
    weak var babyService: BabyService?
    
    //MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectLiveCameraPreview: (() -> Void)?
    var didSelectAddPhoto: (() -> Void)?
    var didSelectDismissImagePicker: (() -> Void)?
    
    init(babyService: BabyService) {
        self.babyService = babyService
    }
    
    //MARK: - Internal functions
    func selectSwitchBaby() {
        didSelectShowBabies?()
    }
    
    func selectLiveCameraPreview() {
        didSelectLiveCameraPreview?()
    }
    
    func selectAddPhoto() {
        didSelectAddPhoto?()
    }
    
    func selectDismissImagePicker() {
        didSelectDismissImagePicker?()
    }
}

