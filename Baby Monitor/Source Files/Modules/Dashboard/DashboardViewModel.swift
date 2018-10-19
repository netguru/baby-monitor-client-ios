//
//  DashboardViewModel.swift
//  Baby Monitor
//

import Foundation

final class DashboardViewModel {

    private var babyService: BabyServiceProtocol

    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectLiveCameraPreview: (() -> Void)?
    var didSelectAddPhoto: (() -> Void)?
    var didSelectDismissImagePicker: (() -> Void)?
    var didLoadBabies: ((_ babies: [Baby]) -> Void)?

    init(babyService: BabyServiceProtocol) {
        self.babyService = babyService
    }

    // MARK: - Internal functions
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
    
    func loadBabies() {
        let babies = babyService.dataSource.babies
        didLoadBabies?(babies)
    }
    
    /// Sets a new photo for the current baby.
    ///
    /// - Parameter photo: A new photo for baby.
    func updatePhoto(_ photo: UIImage) {
        babyService.setPhoto(photo)
    }
    
    /// Sets a new name for the current baby.
    ///
    /// - Parameter name: A new name for baby.
    func updateName(_ name: String) {
        babyService.setName(name)
    }
    
    /// Sets observer to react to changes in the baby.
    ///
    /// - Parameter controller: A controller conformed to BabyServiceObserver.
    func addObserver(to controller: BabyServiceObserver) {
        babyService.addObserver(controller)
    }
    
    /// Removes observer to react to changes in the baby.
    ///
    /// - Parameter controller: A controller conformed to BabyServiceObserver.
    func removeObserver(to controller: BabyServiceObserver) {
        babyService.removeObserver(controller)
    }
}
