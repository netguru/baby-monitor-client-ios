//
//  LullabiesViewModel.swift
//  Baby Monitor
//


import Foundation

protocol LullabiesViewModelCoordinatorDelegate: class {
    func didSelectShowBabiesView()
}

final class LullabiesViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorHeaderCellConfigurable, BabiesViewShowable {
    
    private enum Constants {
        static let bmLibrarySection = 0
        static let yourLullabiesSection = 1
    }
    
    weak var coordinatorDelegate: LullabiesViewModelCoordinatorDelegate?
    
    let numberOfSections = 2
    
    func configure(cell: BabyMonitorCell, for indexPath: IndexPath) {
        cell.type = .lullaby
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        cell.update(mainText: "Sleep My Baby")
        cell.update(secondaryText: "2:30 mins")
    }
    
    func numberOfRows(for section: Int) -> Int {
        //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
        return 3
    }
    
    func selectShowBabies() {
        coordinatorDelegate?.didSelectShowBabiesView()
    }
    
    func configure(headerCell: BabyMonitorCell, for section: Int) {
        headerCell.configureAsHeader()
        switch section {
        case Constants.bmLibrarySection:
            headerCell.update(mainText: Localizable.Lullabies.bmLibrary)
        case Constants.yourLullabiesSection:
            headerCell.update(mainText: Localizable.Lullabies.yourLullabies)
        default:
            break
        }
    }
}
