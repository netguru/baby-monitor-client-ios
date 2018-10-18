//
//  CameraPreviewViewController.swift
//  Baby Monitor
//


import UIKit

final class CameraPreviewViewController: TypedViewController<CameraPreviewView>, MediaPlayerDataSource {
    
    private let viewModel: CameraPreviewViewModel
    
    lazy var videoView = customView.mediaView
    
    init(viewModel: CameraPreviewViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: CameraPreviewView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.babyService?.addObserver(self)
    }
    
    //MARK: - Selectors
    @objc private func didTouchCancelButton() {
        viewModel.selectCancel()
    }
    
    //MARK: - Private functions
    private func setup() {
        viewModel.videoDataSource = self
        navigationItem.leftBarButtonItem = customView.cancelItemButton
        navigationItem.titleView = customView.babyNavigationItemView
        customView.babyNavigationItemView.onSelectArrow = { [weak self] in
            self?.viewModel.selectShowBabies()
        }
        customView.babyNavigationItemView.setBabyName(viewModel.babyService?.dataSource.babies.first?.name)
        customView.babyNavigationItemView.setBabyPhoto(viewModel.babyService?.dataSource.babies.first?.image)
        customView.cancelItemButton.target = self
        customView.cancelItemButton.action = #selector(didTouchCancelButton)
    }
}

extension CameraPreviewViewController: BabyServiceObserver {
    
    func babyService(_ service: BabyService, didChangePhotoOf baby: Baby) {
        guard let newImage = baby.image else { return }
        customView.babyNavigationItemView.setBabyPhoto(newImage)
        print("CHANGE PHOTO IN CAMERA PREVIEW")
    }
    
    func babyService(_ service: BabyService, didChangeNameOf baby: Baby) {
        guard let newName = baby.name else { return }
        customView.babyNavigationItemView.setBabyName(newName)
    }
}
