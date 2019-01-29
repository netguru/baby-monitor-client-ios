//
//  DashboardViewModel.swift
//  Baby Monitor
//

import Foundation
import RxCocoa
import RxSwift

final class DashboardViewModel {

    private let babyModelController: BabyModelControllerProtocol
    private let bag = DisposeBag()

    // MARK: - Coordinator callback
    private(set) var liveCameraPreview: Observable<Void>?
    private(set) var addPhoto: Observable<Void>?
    lazy var dismissImagePicker: Observable<Void> = dismissImagePickerSubject.asObservable()
    
    private let dismissImagePickerSubject = PublishRelay<Void>()
    
    lazy var baby: Observable<Baby> = babyModelController.babyUpdateObservable
    lazy var connectionStatus: Observable<ConnectionStatus> = connectionChecker.connectionStatus

    // MARK: - Private properties
    private let connectionChecker: ConnectionChecker

    init(connectionChecker: ConnectionChecker, babyModelController: BabyModelControllerProtocol) {
        self.connectionChecker = connectionChecker
        self.babyModelController = babyModelController
        setup()
    }

    deinit {
        connectionChecker.stop()
    }
    
    func selectDismissImagePicker() {
        dismissImagePickerSubject.accept(())
    }

    // TODO: Remove when baby service is done https://netguru.atlassian.net/browse/BM-119
    /// Sets a new photo for the current baby.
    ///
    /// - Parameter photo: A new photo for baby.
    func updatePhoto(_ photo: UIImage) {
        babyModelController.updatePhoto(photo)
    }
    
    // MARK: - Private functions
    private func setup() {
        connectionChecker.start()
    }
}
