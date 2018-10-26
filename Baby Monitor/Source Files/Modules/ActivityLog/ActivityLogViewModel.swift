//
//  ActivityLogViewModel.swift
//  Baby Monitor
//

import UIKit

final class ActivityLogViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorHeaderCellConfigurable, BabiesViewSelectable {

    private let babyRepo: BabiesRepositoryProtocol

    var numberOfSections: Int {
        return 1
    }

    init(babyRepo: BabiesRepositoryProtocol) {
        self.babyRepo = babyRepo
    }

    // MARK: - Coordinator callback
    var didSelectShowBabies: (() -> Void)?
    var didLoadBabies: ((_ baby: Baby) -> Void)?

    // MARK: - Internal functions
    func selectShowBabies() {
        didSelectShowBabies?()
    }

    func configure(cell: BabyMonitorCell, for indexPath: IndexPath) {
        cell.type = .activityLog
        // TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        cell.update(secondaryText: "24 minutes ago")
        if let currentBaby = babyRepo.fetchAllBabies().first {
            cell.update(image: currentBaby.photo ?? UIImage())
            cell.update(mainText: "\(currentBaby.name) was crying!")
        }
    }

    func configure(headerCell: BabyMonitorCell, for section: Int) {
        headerCell.configureAsHeader()
        headerCell.update(mainText: "Yesterday")
    }

    func numberOfRows(for section: Int) -> Int {
        return 5 //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
    }
    
    func loadBabies() {
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        didLoadBabies?(baby)
    }
    
    /// Sets observer to react to changes in the baby.
    ///
    /// - Parameter observer: An object conformed to BabyRepoObserver protocol.
    func addObserver(_ observer: BabyRepoObserver) {
        babyRepo.addObserver(observer)
    }
    
    /// Removes observer to react to changes in the baby.
    ///
    /// - Parameter observer: An object conformed to BabyRepoObserver protocol.
    func removeObserver(_ observer: BabyRepoObserver) {
        babyRepo.removeObserver(observer)
    }
}
