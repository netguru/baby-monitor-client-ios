//
//  OnboardingClientSetupViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

enum PairingSearchState {
    case noneFound, someFound, timeoutReached
}

final class OnboardingClientSetupViewController: TypedViewController<OnboardingSpinnerView> {
    
    private let viewModel: ClientSetupOnboardingViewModel
    private let bag = DisposeBag()
    private var devices: [NetServiceDescriptor] = []
    init(viewModel: ClientSetupOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: OnboardingSpinnerView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startDiscovering(withTimeout: Constants.pairingDeviceSearchTimeLimit)
    }
    
    private func setup() {
        customView.update(title: viewModel.title)
        updateView(for: .noneFound)
        navigationItem.leftBarButtonItem = customView.backButtonItem
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        setupBindings()
    }

    private func updateView(for state: PairingSearchState) {
        customView.update(mainDescription: viewModel.description)
        customView.update(buttonTitle: viewModel.buttonTitle)
        customView.update(for: state)
    }

    private func setupBindings() {
        viewModel.attachInput(cancelButtonTap: customView.rx.bottomButtonTap.asObservable())
        viewModel.availableDevicesPublisher
            .skip(1)
            .subscribe(onNext: { [weak self] devices in
                self?.devices = devices
            }).disposed(by: bag)
        viewModel.state
            .skip(1)
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
