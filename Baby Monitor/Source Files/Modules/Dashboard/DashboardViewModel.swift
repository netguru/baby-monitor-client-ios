//
//  DashboardViewModel.swift
//  Baby Monitor
//

import Foundation

final class DashboardViewModel {

    private let babyRepo: BabiesRepository

    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didSelectLiveCameraPreview: (() -> Void)?
    var didSelectAddPhoto: (() -> Void)?
    var didSelectDismissImagePicker: (() -> Void)?
    var didLoadBabies: ((_ baby: Baby) -> Void)?
    var didUpdateStatus: ((ConnectionStatus) -> Void)?

    // MARK: - Private properties
    private let connectionChecker: ConnectionChecker

    init(connectionChecker: ConnectionChecker, babyRepo: BabiesRepository) {
        self.connectionChecker = connectionChecker
        self.babyRepo = babyRepo
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
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        didLoadBabies?(baby)
    }

    /// Sets a new photo for the current baby.
    ///
    /// - Parameter photo: A new photo for baby.
    func updatePhoto(_ photo: UIImage) {
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        babyRepo.setPhoto(photo, id: baby.id)
    }

    /// Sets a new name for the current baby.
    ///
    /// - Parameter name: A new name for baby.
    func updateName(_ name: String) {
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        babyRepo.setName(name, id: baby.id)
    }

    /// Sets observer to react to changes in the baby.
    ///
    /// - Parameter controller: A controller conformed to BabyRepoObserver.
    func addObserver(_ observer: BabyRepoObserver) {
        babyRepo.addObserver(observer)
    }

    /// Removes observer to react to changes in the baby.
    ///
    /// - Parameter controller: A controller conformed to BabyRepoObserver.
    func removeObserver(_ observer: BabyRepoObserver) {
        babyRepo.removeObserver(observer)
    }

    // MARK: - Private functions
    private func setup() {
        connectionChecker.didUpdateStatus = { [weak self] status in
            self?.didUpdateStatus?(status)
        }
        connectionChecker.start()
    }
}
