//
//  DashboardViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class DashboardViewController: TypedViewController<DashboardView>, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BabyServiceUpdatable {

    private let viewModel: DashboardViewModel
    private let bag = DisposeBag()

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: DashboardView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModel()
    }

    deinit {
        viewModel.removeObserver(self)
    }

    func updateViews(with baby: Baby) {
        updateName(baby.name)
        updatePhoto(baby.photo)
    }

    func updateName(_ name: String) {
        customView.updateName(name)
    }

    func updatePhoto(_ photo: UIImage?) {
        customView.updatePhoto(photo)
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        viewModel.updatePhoto(image)
        viewModel.selectDismissImagePicker()
    }

    // MARK: - Selectors
    @objc private func didTouchEditProfileButton() {
        //TODO: add implementation
    }

    // MARK: - Private functions
    private func setup() {
        navigationItem.rightBarButtonItem = customView.editProfileBarButtonItem
        navigationItem.titleView = customView.babyNavigationItemView
    }
    
    private func setupViewModel() {
        viewModel.addObserver(self)
        viewModel.attachInput(switchBabyTap: customView.rx.switchBabyTap.asObservable(), liveCameraTap: customView.rx.liveCameraTap.asObservable(), addPhotoTap: customView.rx.addPhotoTap.asObservable(), name: customView.rx.babyName.asObservable())
        // TODO: Remove imperative call to babies fetching https://netguru.atlassian.net/browse/BM-119c
        viewModel.loadBabies()
        viewModel.baby
            .map { $0.name }
            .bind(to: customView.rx.babyName)
            .disposed(by: bag)
        viewModel.baby
            .map { $0.photo }
            .bind(to: customView.rx.babyPhoto)
            .disposed(by: bag)
        viewModel.connectionStatus
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] status in
                self?.handleConnectionStatusChange(status: status)
            })
            .disposed(by: bag)
    }
    
    private func handleConnectionStatusChange(status: ConnectionStatus) {
        switch status {
        case .connected:
            customView.showIsConnected()
        case .disconnected:
            customView.showIsDisconnected()
        }
    }
}

// TODO: Remove when rx is integrated into baby service https://netguru.atlassian.net/browse/BM-119
extension DashboardViewController: BabyServiceObserver {

    func babyService(_ service: BabyServiceProtocol, didChangePhotoOf baby: Baby) {
        updatePhoto(baby.photo)
    }

    func babyService(_ service: BabyServiceProtocol, didChangeNameOf baby: Baby) {
        updateName(baby.name)
    }
}
