//
//  OnboardingClientSetupViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

enum PairingSearchState {
    case noneFound, someFound, timeoutReached
}

final class OnboardingClientSetupViewController: TypedViewController<OnboardingClientSetupView> {
    
    private let viewModel: OnboardingClientSetupViewModel
    private let bag = DisposeBag()
    private var devices: [NetServiceDescriptor] = []
    init(viewModel: OnboardingClientSetupViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: OnboardingClientSetupView(),
                   analytics: viewModel.analytics,
                   analyticsScreenType: .availableDevices)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopDiscovering()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startDiscovering(withTimeout: Constants.pairingDeviceSearchTimeLimit)
    }
    
    private func setup() {
        customView.update(title: viewModel.title)
        customView.update(mainDescription: viewModel.description)
        customView.update(buttonTitle: viewModel.buttonTitle)
        navigationItem.leftBarButtonItem = customView.backButtonItem
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        setupBindings()
    }

    private func updateView(for state: PairingSearchState) {
        customView.update(for: state)
    }

    private func setupBindings() {
        viewModel.attachInput(refreshButtonTap: customView.rx.bottomButtonTap.asObservable())
        viewModel.availableDevicesPublisher
            .skip(1)
            .subscribe(onNext: { [weak self] devices in
                self?.devices = devices
                self?.customView.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            }).disposed(by: bag)
        viewModel.state
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                self?.updateView(for: state)
            }).disposed(by: bag)
        customView.rx.backButtonTap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: bag)
    }
}

extension OnboardingClientSetupViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as AvailablePairingDevicesTableViewCell
        cell.configure(with: devices[indexPath.row].deviceName)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.pair(with: devices[indexPath.row])
    }
}
