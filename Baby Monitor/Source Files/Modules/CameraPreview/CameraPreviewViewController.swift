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
    
    // MARK: - Selectors
    @objc private func didTouchCancelButton() {
        viewModel.selectCancel()
    }
    
    // MARK: - Private functions
    private func setup() {
        viewModel.videoDataSource = self
        navigationItem.leftBarButtonItem = customView.cancelItemButton
        navigationItem.titleView = customView.babyNavigationItemView
        customView.babyNavigationItemView.onSelectArrow = { [weak self] in
            self?.viewModel.selectShowBabies()
        }
        customView.babyNavigationItemView.setBabyName(viewModel.babyService?.dataSource.babies.first?.name)
        customView.babyNavigationItemView.setBabyPhoto(viewModel.babyService?.dataSource.babies.first?.photo)
        customView.cancelItemButton.target = self
        customView.cancelItemButton.action = #selector(didTouchCancelButton)
    }
}

extension CameraPreviewViewController: BabyServiceObserver {
    
    func babyService(_ service: BabyServiceProtocol, didChangePhotoOf baby: Baby) {
        customView.babyNavigationItemView.setBabyPhoto(baby.photo)
    }
    
    func babyService(_ service: BabyServiceProtocol, didChangeNameOf baby: Baby) {
        customView.babyNavigationItemView.setBabyName(baby.name)
    }
}
