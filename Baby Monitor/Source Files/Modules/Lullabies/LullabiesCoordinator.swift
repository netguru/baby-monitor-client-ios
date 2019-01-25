//
//  LullabiesCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import MediaPlayer

final class LullabiesCoordinator: NSObject, Coordinator {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var onEnding: (() -> Void)?
    
    private var lullabiesViewController: BabyMonitorGeneralViewController<Lullaby>?
    private var lullabiesViewModel: LullabiesViewModel?
    private let bag = DisposeBag()
    
    init(_ navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    func start() {
        showLullabies()
    }
    
    // MARK: - private functions
    private func showLullabies() {
        let viewModel = LullabiesViewModel(babyModelController: appDependencies.databaseRepository, lullabiesRepo: appDependencies.lullabiesRepository)
        lullabiesViewModel = viewModel
        lullabiesViewController = BabyMonitorGeneralViewController(viewModel: AnyBabyMonitorGeneralViewModelProtocol<Lullaby>(viewModel: viewModel), type: .lullaby)
        lullabiesViewController?.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self?.didTapAddButton))
                self?.lullabiesViewController?.navigationItem.rightBarButtonItems = [button]
            })
            .disposed(by: bag)
        navigationController.pushViewController(lullabiesViewController!, animated: false)
    }
    
    @objc
    private func didTapAddButton() {
        let mediaPickerController = MPMediaPickerController(mediaTypes: .music)
        mediaPickerController.delegate = self
        navigationController.present(mediaPickerController, animated: true)
    }
}

extension LullabiesCoordinator: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let lullabies = mediaItemCollection.items
            .filter { $0.assetURL != nil && $0.title != nil }
            .map { ($0.title!, $0.assetURL!.absoluteString) }
            .map { title, url in
                Lullaby(name: title, identifier: url, type: .yourLullabies)
            }
        lullabiesViewModel?.save(lullabies: lullabies)
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
}
