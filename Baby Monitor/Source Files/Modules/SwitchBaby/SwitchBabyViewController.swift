//
//  SwitchBabyViewController.swift
//  Baby Monitor
//


import UIKit

final class SwitchBabyViewController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(BabyMonitorCell.self, forCellReuseIdentifier: BabyMonitorCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.75
        return view
    }()
    
    private let viewModel: SwitchBabyTableViewModel
    
    init(viewModel: SwitchBabyTableViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    //MARK: - private functions
    private func setup() {
        view.backgroundColor = .clear
        [backgroundView, tableView].forEach {
            view.addSubview($0)
            $0.addConstraints({ $0.equalSafeAreaEdges() })
        }
    }
}

//MARK: - UITableViewDataSource
extension SwitchBabyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as BabyMonitorCell
        viewModel.configure(cell: cell, for: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SwitchBabyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BabyMonitorCell else {
            return
        }
        viewModel.select(cell: cell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
