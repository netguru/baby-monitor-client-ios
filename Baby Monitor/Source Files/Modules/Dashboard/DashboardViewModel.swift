//
//  DashboardViewModel.swift
//  Baby Monitor
//

import Foundation

final class DashboardViewModel {

    var babyService: BabyServiceProtocol

    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectLiveCameraPreview: (() -> Void)?
    var didSelectAddPhoto: (() -> Void)?
    var didSelectDismissImagePicker: (() -> Void)?

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
}
