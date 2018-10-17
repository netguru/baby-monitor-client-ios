//
//  SettingsViewModel.swift
//  Baby Monitor
//

import Foundation

final class SettingsViewModel: BabyMonitorGeneralViewModelProtocol, BabiesViewSelectable {

    let numberOfSections = 1
    
    //MARK: - Coordinator callback
    var didSelectShowBabiesView: (() -> Void)?
    
    private enum Constants {
        static let switchToServerCell = 0
    }
    
    //MARK: - Internal functions
    func configure(cell: BabyMonitorCell, for indexPath: IndexPath) {
        cell.type = .settings
        switch indexPath.row {
        case Constants.switchToServerCell:
            //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
            cell.update(mainText: Localizable.Settings.switchToServer)
        default:
            break
        }
    }
    
    func numberOfRows(for section: Int) -> Int {
        return 1
    }
    
    func selectShowBabies() {
        didSelectShowBabiesView?()
    }
}
