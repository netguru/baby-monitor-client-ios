//
//  DashboardViewModel.swift
//  Baby Monitor
//

import Foundation
import RxCocoa
import RxSwift

final class DashboardViewModel {

    private let babyService: BabyServiceProtocol

    // MARK: - Coordinator callback
    private(set) var showBabies: Observable<Void>?
    private(set) var liveCameraPreview: Observable<Void>?
    private(set) var addPhoto: Observable<Void>?
    lazy var dismissImagePicker: Observable<Void> = dismissImagePickerSubject.asObservable()
    
    private let dismissImagePickerSubject = PublishRelay<Void>()
    
    // TODO: Remove publisher and assign baby observable directly from service when it's done https://netguru.atlassian.net/browse/BM-119
    lazy var baby: Observable<Baby> = babyPublisher.asObservable()
    private let babyPublisher = PublishRelay<Baby>()
    lazy var connectionStatus: Observable<ConnectionStatus> = connectionStatusPublisher.asObservable()
    private let connectionStatusPublisher = PublishRelay<ConnectionStatus>()

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

    // TODO: Remove when baby service is done https://netguru.atlassian.net/browse/BM-119
    func loadBabies() {
        guard let baby = babyService.dataSource.babies.first else { return }
        babyPublisher.accept(baby)
    }
    
    func selectDismissImagePicker() {
        dismissImagePickerSubject.accept(())
    }
    
    // TODO: Bind name to baby service when it's done https://netguru.atlassian.net/browse/BM-119
    func attachInput(switchBabyTap: Observable<Void>,
                     liveCameraTap: Observable<Void>,
                     addPhotoTap: Observable<Void>,
                     name: Observable<String>) {
        self.showBabies = switchBabyTap
        self.liveCameraPreview = liveCameraTap
        self.addPhoto = addPhotoTap
    }

    // TODO: Remove when baby service is done https://netguru.atlassian.net/browse/BM-119
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
        connectionChecker.start()
    }
}
