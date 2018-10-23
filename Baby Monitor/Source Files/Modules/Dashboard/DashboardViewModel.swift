//
//  DashboardViewModel.swift
//  Baby Monitor
//

import Foundation

final class DashboardViewModel {

    private let babyService: BabyServiceProtocol

    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectLiveCameraPreview: (() -> Void)?
    var didSelectAddPhoto: (() -> Void)?
    var didSelectDismissImagePicker: (() -> Void)?
    var didLoadBabies: ((_ baby: Baby) -> Void)?
    var didUpdateStatus: ((ConnectionStatus) -> Void)?

    // MARK: - Private properties
    private let connectionChecker: ConnectionChecker

    init(connectionChecker: ConnectionChecker, babyService: BabyServiceProtocol) {
        self.connectionChecker = connectionChecker
        self.babyService = babyService
        setup()
    }

    deinit {
        connectionChecker.stop()
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
        guard let baby = babyService.dataSource.babies.first else { return }
        didLoadBabies?(baby)
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
    func addObserver(_ observer: BabyServiceObserver) {
        babyService.addObserver(observer)
    }

    /// Removes observer to react to changes in the baby.
    ///
    /// - Parameter controller: A controller conformed to BabyServiceObserver.
    func removeObserver(_ observer: BabyServiceObserver) {
        babyService.removeObserver(observer)
    }

    // MARK: - Private functions
    private func setup() {
        connectionChecker.didUpdateStatus = { [weak self] status in
            self?.didUpdateStatus?(status)
        }
        connectionChecker.start()
    }
}
