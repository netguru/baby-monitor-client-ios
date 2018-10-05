//
//  BabyMonitorGeneralView.swift
//  Baby Monitor
//


import UIKit

final class BabyMonitorGeneralView: BaseView {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(BabyMonitorCell.self, forCellReuseIdentifier: BabyMonitorCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private(set) lazy var babyNavigationItemView = BabyNavigationItemView(babyName: "Franuś") //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.75
        return view
    }()
    
    init(type: BabyMonitorGeneralViewController.ViewType) {
        super.init()
        setup(type: type)
    }
    
    //MARK: - private functions
    private func setup(type: BabyMonitorGeneralViewController.ViewType) {
        tableView.separatorStyle = .singleLine
        
        switch type {
        case .switchBaby:
            tableView.separatorStyle = .none
            backgroundColor = .clear
            tableView.backgroundColor = .clear
        case .activityLog:
            tableView.tableFooterView = UIView()
            backgroundView.isHidden = true
            tableView.backgroundColor = .white
        }
        
        [backgroundView, tableView].forEach {
            addSubview($0)
            $0.addConstraints({ $0.equalSafeAreaEdges() })
        }
    }
}
