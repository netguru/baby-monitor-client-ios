//
//  ClientSetupOnboardingViewModel.swift
//  Baby Monitor
//

import Foundation
import RxSwift

enum DeviceSearchError: Error {
    case timeout
}

enum DeviceSearchResult: Equatable {
    case success
    case failure(DeviceSearchError)
}

final class ClientSetupOnboardingViewModel: OnboardingViewModelProtocol, ServiceDiscoverable {
    var selectFirstAction: (() -> Void)?
    var selectSecondAction: (() -> Void)?
    
    // MARK: - Coordinator callback
    var didFinishDeviceSearch: ((DeviceSearchResult) -> Void)?
    
    private var searchCancelTimer: Timer?
    private let netServiceClient: NetServiceClientProtocol
    private let urlConfiguration: URLConfiguration
    private let babyRepo: BabiesRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(netServiceClient: NetServiceClientProtocol, urlConfiguration: URLConfiguration, babyRepo: BabiesRepositoryProtocol) {
        self.netServiceClient = netServiceClient
        self.urlConfiguration = urlConfiguration
        self.babyRepo = babyRepo
    }
    
    func startDiscovering(withTimeout timeout: TimeInterval = 5.0) {
        searchCancelTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { [weak self] _ in
            self?.didFinishDeviceSearch?(.failure(.timeout))
            self?.netServiceClient.stopFinding()
            self?.searchCancelTimer = nil
        })
        netServiceClient.serviceObservable
            .take(1)
            .subscribe(onNext: { [weak self] ip, port in
            self?.searchCancelTimer?.invalidate()
                guard let serverUrl = URL.with(ip: ip, port: port, prefix: Constants.protocolPrefix),
                let self = self else {
                return
            }
            self.urlConfiguration.url = serverUrl
            self.netServiceClient.stopFinding()
            self.didFinishDeviceSearch?(.success)
            self.setupBaby()
        })
        .disposed(by: disposeBag)
        netServiceClient.findService()
    }
    
    private func setupBaby() {
        if let baby = babyRepo.fetchAllBabies().first {
            babyRepo.setCurrentBaby(baby: baby)
        } else {
            let baby = Baby(name: "Anonymous")
            try! babyRepo.save(baby: Baby(name: "Anonymous"))
            babyRepo.setCurrentBaby(baby: baby)
        }
    }
}
