//
//  CameraPreviewViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class CameraPreviewViewController: TypedViewController<CameraPreviewView>, MediaPlayerDataSource {
    
    private let viewModel: CameraPreviewViewModel
    
    lazy var videoView = customView.mediaView
    
    private let bag = DisposeBag()
    
    init(viewModel: CameraPreviewViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: CameraPreviewView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModel()
    }
    
    // MARK: - Selectors
    @objc private func didTouchCancelButton() {
        viewModel.selectCancel()
    }
    
    // MARK: - Private functions
    private func setup() {
        navigationItem.leftBarButtonItem = customView.cancelItemButton
        navigationItem.titleView = customView.babyNavigationItemView
        customView.rx.switchBabiesTap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.selectShowBabies()
            })
            .disposed(by: bag)
        customView.cancelItemButton.target = self
        customView.cancelItemButton.action = #selector(didTouchCancelButton)
    }
    
    private func setupViewModel() {
        viewModel.videoDataSource = self
        viewModel.baby
            .map { $0.name }
            .bind(to: customView.rx.babyName)
            .disposed(by: bag)
        viewModel.baby
            .map { $0.photo }
            .bind(to: customView.rx.babyPhoto)
            .disposed(by: bag)
    }
}
