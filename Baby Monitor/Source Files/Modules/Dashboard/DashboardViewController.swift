//
//  DashboardViewController.swift
//  Baby Monitor
//

import UIKit

final class DashboardViewController: TypedViewController<DashboardView>, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    private let viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: DashboardView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.babyService.addObserver(self)
    }
    
    deinit {
        viewModel.babyService.removeObserver(self)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        viewModel.babyService.setPhoto(image)

        viewModel.selectDismissImagePicker()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.babyService.setName(textField.text!)
        customView.endEditing(true)
        return false
    }
    
    // MARK: - Selectors
    @objc private func didTouchEditProfileButton() {
        //TODO: add implementation
    }
    
    // MARK: - Private functions
    private func setup() {
        navigationItem.rightBarButtonItem = customView.editProfileBarButtonItem
        navigationItem.titleView = customView.babyNavigationItemView
        customView.babyNavigationItemView.onSelectArrow = { [weak self] in
            self?.viewModel.selectSwitchBaby()
        }
        customView.liveCameraButton.onSelect = { [weak self] in
            self?.viewModel.selectLiveCameraPreview()
        }
        customView.photoButtonView.onSelect = { [weak self] in
            self?.viewModel.selectAddPhoto()
        }
        customView.nameField.text = viewModel.babyService.dataSource.babies.first?.name
        customView.photoButtonView.setPhoto(viewModel.babyService.dataSource.babies.first?.photo)
        customView.babyNavigationItemView.setBabyName(viewModel.babyService.dataSource.babies.first?.name)
        customView.babyNavigationItemView.setBabyPhoto(viewModel.babyService.dataSource.babies.first?.photo)
        
        customView.nameField.delegate = self
    }
}

extension DashboardViewController: BabyServiceObserver {
    
    func babyService(_ service: BabyService, didChangePhotoOf baby: Baby) {
        customView.photoButtonView.setPhoto(baby.photo)
        customView.babyNavigationItemView.setBabyPhoto(baby.photo)
    }
    
    func babyService(_ service: BabyService, didChangeNameOf baby: Baby) {
        customView.nameField.text = baby.name
        customView.babyNavigationItemView.setBabyName(baby.name)
    }
}
