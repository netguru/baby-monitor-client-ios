//
//  ActivityLogViewModel.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa

final class ActivityLogViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorHeaderCellConfigurable, BabiesViewSelectable {
    
    typealias DataType = Baby
    
    private let babyRepo: BabiesRepository

    init(babyRepo: BabiesRepository) {
        self.babyRepo = babyRepo
    }

    // MARK: - Coordinator callback
    private(set) var showBabies: Observable<Void>?
    var baby: Observable<Baby> {
        return babyPublisher.asObservable()
    }
    private let babyPublisher = PublishRelay<Baby>()
    var sections: Observable<[GeneralSection<Baby>]> {
        return Observable.just(babyRepo.fetchAllBabies())
            .map { [GeneralSection(title: "", items: $0)] }
    }
    
    // MARK: - Internal functions
    func attachInput(showBabiesTap: ControlEvent<Void>) {
        showBabies = showBabiesTap.asObservable()
    }
    
    func configure(cell: BabyMonitorCell, for data: Baby) {
        cell.type = .activityLog
        let baby = data
        // TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        cell.update(secondaryText: "24 minutes ago")
        cell.update(image: baby.photo ?? UIImage())
        cell.update(mainText: "\(baby.name) was crying!")
    }

    func configure(headerCell: BabyMonitorCell, for section: Int) {
        headerCell.configureAsHeader()
        headerCell.update(mainText: "Yesterday")
    }

    func loadBabies() {
        guard let baby = babyRepo.fetchAllBabies().first else { return }
        babyPublisher.accept(baby)
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
