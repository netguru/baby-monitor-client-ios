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
        viewModel.addObserver(to: self)
    }
    
    deinit {
        viewModel.removeObserver(to: self)
    }
    
    func updateViews(with babies: [Baby]) {
        updateName(babies.first!.name)
        updatePhoto(babies.first!.photo)
    }
    
    func updateName(_ name: String) {
        customView.nameField.text = name
        customView.babyNavigationItemView.setBabyName(name)
    }
    
    func updatePhoto(_ photo: UIImage?) {
        customView.photoButtonView.setPhoto(photo)
        customView.babyNavigationItemView.setBabyPhoto(photo)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        viewModel.updatePhoto(image)
        viewModel.selectDismissImagePicker()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.updateName(textField.text!)
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
        customView.nameField.delegate = self
        viewModel.loadBabies()
    }
}

extension DashboardViewController: BabyServiceObserver {
    
    func babyService(_ service: BabyServiceProtocol, didChangePhotoOf baby: Baby) {
        updatePhoto(baby.photo)
    }
    
    func babyService(_ service: BabyServiceProtocol, didChangeNameOf baby: Baby) {
        updateName(baby.name)
    }
}
