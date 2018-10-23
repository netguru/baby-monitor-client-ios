//
//  CameraPreviewViewController.swift
//  Baby Monitor
//

import UIKit

final class CameraPreviewViewController: TypedViewController<CameraPreviewView>, MediaPlayerDataSource, BabyRepoUpdatable {
    
    private let viewModel: CameraPreviewViewModel
    
    lazy var videoView = customView.mediaView
    
    init(viewModel: CameraPreviewViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: CameraPreviewView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModel()
    }
    
    func updateViews(with baby: Baby) {
        updateName(baby.name)
        updatePhoto(baby.photo)
    }
    
    func updateName(_ name: String) {
        customView.babyNavigationItemView.setBabyName(name)
    }
    
    func updatePhoto(_ photo: UIImage?) {
        customView.babyNavigationItemView.setBabyPhoto(photo)
    }
    
    // MARK: - Selectors
    @objc private func didTouchCancelButton() {
        viewModel.selectCancel()
    }
    
    // MARK: - Private functions
    private func setup() {
        navigationItem.leftBarButtonItem = customView.cancelItemButton
        navigationItem.titleView = customView.babyNavigationItemView
        customView.babyNavigationItemView.onSelectArrow = { [weak self] in
            self?.viewModel.selectShowBabies()
        }
        customView.cancelItemButton.target = self
        customView.cancelItemButton.action = #selector(didTouchCancelButton)
    }
    
    private func setupViewModel() {
        viewModel.videoDataSource = self
        viewModel.didLoadBabies = { [weak self] baby in
            self?.updateViews(with: baby)
        }
        viewModel.loadBabies()
    }
}
