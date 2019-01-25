//
//  ParentSettingsViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

class ParentSettingsViewController: TypedViewController<SettingsView> {

    private let viewModel: SettingsViewModel
    private let bag = DisposeBag()

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: SettingsView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.babyMonitorNonTranslucentWhite, .font: UIFont.customFont(withSize: .body)]
        setup()
        setupViewModel()
    }

    // MARK: - Private functions
    private func setup() {
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_back"), style: .plain, target: self, action: #selector(cancel))
    }

    private func setupViewModel() {
        viewModel.attachInput(babyName: customView.rx.babyName.asObservable())
        viewModel.baby
            .map { $0.name }
            .distinctUntilChanged()
            .bind(to: customView.rx.babyName)
            .disposed(by: bag)
        viewModel.baby
            .map { $0.photo }
            .distinctUntilChanged()
            .bind(to: customView.rx.babyPhoto)
            .disposed(by: bag)
    }

    @objc
    func cancel() {
        navigationController?.popViewController(animated: true)
    }
}
