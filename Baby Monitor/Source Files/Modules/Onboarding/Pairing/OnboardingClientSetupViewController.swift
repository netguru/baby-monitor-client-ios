//
//  OnboardingClientSetupViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift

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
        customView.update(mainDescription: viewModel.description)
        customView.update(image: viewModel.image)
        customView.tableView.isHidden = true
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        setupBindings()
    }

    private func setupBindings() {
        viewModel.attachInput(cancelButtonTap: customView.rx.cancelTap.asObservable())
        customView.rx.cancelTap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        })
        .disposed(by: bag)

        viewModel.availableDevicesPublisher
            .skip(1)
            .subscribe(onNext: { [weak self] devices in
                self?.devices = devices
                self?.customView.stopLoading()
                self?.customView.tableView.isHidden = false
                self?.customView.tableView.reloadData()
            }).disposed(by: bag)
    }
}

extension OnboardingClientSetupViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as AvailablePairingDevicesTableViewCell
        cell.configure(with: devices[indexPath.row].name)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.pair(with: devices[indexPath.row])
    }
}
