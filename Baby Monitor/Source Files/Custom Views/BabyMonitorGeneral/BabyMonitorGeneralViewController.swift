//
//  SwitchBabyViewController.swift
//  Baby Monitor
//


import UIKit

final class BabyMonitorGeneralViewController: TypedViewController<BabyMonitorGeneralView>, UITableViewDataSource, UITableViewDelegate {
    
    enum ViewType {
        case switchBaby
        case activityLog
        case lullaby
        case settings
    }
    
    private let viewModel: BabyMonitorGeneralViewModelProtocol
    private let viewType: ViewType
    
    init(viewModel: BabyMonitorGeneralViewModelProtocol, type: ViewType) {
        self.viewModel = viewModel
        self.viewType = type
        super.init(viewMaker: BabyMonitorGeneralView(type: type))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private functions
    private func setup() {
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        let navigationView = customView.babyNavigationItemView
        navigationView.onSelectArrow = { [weak self] in
            guard let babiesViewShowableViewModel = self?.viewModel as? BabiesViewSelectable else {
                return
            }
            babiesViewShowableViewModel.selectShowBabies()
        }
        
        switch viewType {
        case .activityLog, .lullaby, .settings:
            navigationItem.titleView = navigationView
        case .switchBaby:
            break
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as BabyMonitorCell
        viewModel.configure(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerConfigurableViewModel = viewModel as? BabyMonitorHeaderCellConfigurable else {
            return nil
        }
        
        let headerCell = tableView.dequeueReusableCell() as BabyMonitorCell
        headerConfigurableViewModel.configure(headerCell: headerCell, for: section)
        return headerCell
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BabyMonitorCell,
            let cellSelectableViewModel = viewModel as? BabyMonitorCellSelectable else {
                return
        }
        
        cellSelectableViewModel.select(cell: cell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = viewModel as? BabyMonitorHeaderCellConfigurable else {
            return 0
        }
        return 70
    }
}
