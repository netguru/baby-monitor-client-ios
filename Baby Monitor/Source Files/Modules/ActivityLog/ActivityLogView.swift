//
//  ActivityLogView.swift
//  Baby Monitor
//

import UIKit

final class ActivityLogView: BaseView {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ActivityLogCell.self, forCellReuseIdentifier: ActivityLogCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    let cancelItemButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowBack"),
                                           style: .plain,
                                           target: nil,
                                           action: nil)
    
    private lazy var tableFooterView: UIView = {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        view.textAlignment =  .center
        view.contentMode = .top
        view.numberOfLines = 0
        view.font = UIFont.customFont(withSize: .body, weight: .light)
        view.text = Localizable.ActivityLog.noMoreNotificationsMessage
        view.textColor = .babyMonitorLightPurple
        return view
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    // MARK: - private functions
    private func setup() {
        backgroundColor = .babyMonitorDarkGray
        setupBackgroundImage(UIImage())
        tableView.backgroundColor = .babyMonitorDarkGray
        tableView.tableFooterView = tableFooterView
        addSubview(tableView)
        tableView.addConstraints({ $0.equalSafeAreaEdges() })
    }
}
