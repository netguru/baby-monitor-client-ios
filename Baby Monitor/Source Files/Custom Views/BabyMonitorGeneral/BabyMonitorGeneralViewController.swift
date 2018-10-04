//
//  SwitchBabyViewController.swift
//  Baby Monitor
//


import UIKit

final class BabyMonitorGeneralViewController: BaseViewController {
    
    enum `Type` {
        case switchBaby
        case activityLog
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(BabyMonitorCell.self, forCellReuseIdentifier: BabyMonitorCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var babyNavigationItemView = BabyNavigationItemView(babyName: "Franuś") //TODO: mock for now
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.75
        return view
    }()
    
    private let viewModel: BabyMonitorGeneralViewModelProtocol
    private let type: Type
    
    init(viewModel: BabyMonitorGeneralViewModelProtocol, type: Type) {
        self.type = type
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    //MARK: - private functions
    private func setup() {
        tableView.separatorStyle = .singleLine
        
        babyNavigationItemView.onSelectArrow = { [weak self] in
            guard let babiesViewShowableViewModel = self?.viewModel as? BabiesViewShowable else {
                return
            }
            babiesViewShowableViewModel.selectShowBabies()
        }
        
        switch type {
        case .switchBaby:
            tableView.separatorStyle = .none
            view.backgroundColor = .clear
        case .activityLog:
            navigationItem.titleView = babyNavigationItemView
            tableView.tableFooterView = UIView()
            backgroundView.isHidden = true
        }
        
        [backgroundView, tableView].forEach {
            view.addSubview($0)
            $0.addConstraints({ $0.equalSafeAreaEdges() })
        }
    }
}

//MARK: - UITableViewDataSource
extension BabyMonitorGeneralViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
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
}

//MARK: - UITableViewDelegate
extension BabyMonitorGeneralViewController: UITableViewDelegate {
    
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
