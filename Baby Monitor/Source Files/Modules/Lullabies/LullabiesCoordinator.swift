//
//  LullabiesCoordinator.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import MediaPlayer

final class LullabiesCoordinator: NSObject, Coordinator, BabiesViewShowable {
    
    var appDependencies: AppDependencies
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var switchBabyViewController: BabyMonitorGeneralViewController<SwitchBabyViewModel.Cell>?
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
        let viewModel = LullabiesViewModel(babyRepo: appDependencies.babyRepo, lullabiesRepo: appDependencies.lullabiesRepo)
        lullabiesViewModel = viewModel
        lullabiesViewController = BabyMonitorGeneralViewController(viewModel: AnyBabyMonitorGeneralViewModelProtocol<Lullaby>(viewModel: viewModel), type: .lullaby)
        lullabiesViewController?.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.connect(toLullabiesViewModel: viewModel)
                let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self?.didTapAddButton(_:)))
                self?.lullabiesViewController?.navigationItem.rightBarButtonItems = [button]
            })
            .disposed(by: bag)
        navigationController.pushViewController(lullabiesViewController!, animated: false)
    }
    
    @objc
    private func didTapAddButton(_ sender: UIBarButtonItem) {
        let mediaPickerController = MPMediaPickerController(mediaTypes: .music)
        mediaPickerController.delegate = self
        navigationController.present(mediaPickerController, animated: true)
    }
    
    private func connect(toLullabiesViewModel viewModel: LullabiesViewModel) {
        viewModel.showBabies?
            .subscribe(onNext: { [weak self] in
                guard let self = self, let lullabiesViewController = self.lullabiesViewController else {
                    return
                }
                self.toggleSwitchBabiesView(on: lullabiesViewController, babyRepo: self.appDependencies.babyRepo)
            })
            .disposed(by: bag)
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
