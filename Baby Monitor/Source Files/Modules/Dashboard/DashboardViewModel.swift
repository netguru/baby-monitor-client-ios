//
//  DashboardViewModel.swift
//  Baby Monitor
//

import Foundation
import RxCocoa
import RxSwift

final class DashboardViewModel {

    private let babyRepo: BabiesRepositoryProtocol
    
    private let bag = DisposeBag()

    // MARK: - Coordinator callback
    private(set) var showBabies: Observable<Void>?
    private(set) var liveCameraPreview: Observable<Void>?
    private(set) var addPhoto: Observable<Void>?
    lazy var dismissImagePicker: Observable<Void> = dismissImagePickerSubject.asObservable()
    
    private let dismissImagePickerSubject = PublishRelay<Void>()
    
    lazy var baby: Observable<Baby> = babyRepo.babyUpdateObservable
    lazy var connectionStatus: Observable<ConnectionStatus> = connectionChecker.connectionStatus

    // MARK: - Private properties
    private let connectionChecker: ConnectionChecker

    init(connectionChecker: ConnectionChecker, babyRepo: BabiesRepositoryProtocol) {
        self.connectionChecker = connectionChecker
        self.babyRepo = babyRepo
        setup()
    }

    deinit {
        connectionChecker.stop()
    }
    
    func selectDismissImagePicker() {
        dismissImagePickerSubject.accept(())
    }
    
    func attachInput(switchBabyTap: Observable<Void>,
                     liveCameraTap: Observable<Void>,
                     addPhotoTap: Observable<Void>,
                     name: Observable<String>) {
        showBabies = switchBabyTap
        liveCameraPreview = liveCameraTap
        addPhoto = addPhotoTap
        name.subscribe(onNext: { [weak self] name in
            self?.babyRepo.setCurrentName(name)
        })
            .disposed(by: bag)
    }

    // TODO: Remove when baby service is done https://netguru.atlassian.net/browse/BM-119
    /// Sets a new photo for the current baby.
    ///
    /// - Parameter photo: A new photo for baby.
    func updatePhoto(_ photo: UIImage) {
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        babyRepo.setPhoto(photo, id: baby.id)
    }
    
    // MARK: - Private functions
    private func setup() {
        connectionChecker.start()
    }
}
