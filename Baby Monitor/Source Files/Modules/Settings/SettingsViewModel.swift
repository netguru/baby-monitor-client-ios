//
//  SettingsViewModel.swift
//  Baby Monitor
//

import Foundation

final class SettingsViewModel: BabyMonitorGeneralViewModelProtocol, BabiesViewSelectable {

    let numberOfSections = 1
    
    // MARK: - Coordinator callback
    var didSelectShowBabiesView: (() -> Void)?
    var didSelectChangeServer: (() -> Void)?
    
    private enum Constants {
        enum Cell: Int, CaseIterable {
            case switchToServer = 0
            case changeServer = 1
        }
    }
    
    // MARK: - Internal functions
    func configure(cell: BabyMonitorCell, for indexPath: IndexPath) {
        cell.type = .settings
        switch indexPath.row {
        case Constants.Cell.switchToServer.rawValue:
            //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
            cell.update(mainText: Localizable.Settings.switchToServer)
        case Constants.Cell.changeServer.rawValue:
            cell.update(mainText: Localizable.Settings.changeServer)
            cell.didTap = { [weak self] in
                self?.didSelectChangeServer?()
            }
        default:
            break
        }
    }
    
    func numberOfRows(for section: Int) -> Int {
        return Constants.Cell.allCases.count
    }
    
    func selectShowBabies() {
        didSelectShowBabiesView?()
    }
}
