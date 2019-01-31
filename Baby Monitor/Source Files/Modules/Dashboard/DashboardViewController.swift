//
//  DashboardViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

final class DashboardViewController: TypedViewController<DashboardView>, UINavigationControllerDelegate {

    private var timer: Timer?
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
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true, block: { [weak self] _ in
            self?.customView.firePulse()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.timer?.fire()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = customView.settingsBarButtonItem
    }

    // MARK: - Private functions
    private func setup() {
        view.backgroundColor = .babyMonitorDarkGray
        navigationItem.titleView = customView.babyNavigationItemView
    }
    
    private func setupViewModel() {
        viewModel.attachInput(
            liveCameraTap: customView.rx.liveCameraTap.asObservable(),
            activityLogTap: customView.rx.activityLogTap.asObservable(),
            settingsTap: customView.rx.settingsTap.asObservable())
        viewModel.baby
            .map { $0.name }
            .distinctUntilChanged()
            .bind(to: customView.rx.babyName)
            .disposed(by: bag)
        viewModel.baby
            .map { $0.photo }
            .filter { $0 != nil }
            .distinctUntilChanged()
            .bind(to: customView.rx.babyPhoto)
            .disposed(by: bag)
        viewModel.connectionStatus
            .distinctUntilChanged()
            .map { $0 == .connected }
            .bind(to: customView.rx.connectionStatus)
            .disposed(by: bag)
    }
}
