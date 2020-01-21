//
//  ActivityLogViewController.swift
//  Baby Monitor
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ActivityLogViewController: TypedViewController<ActivityLogView>, UITableViewDelegate, UITableViewDataSource {
    
    private enum GeneralConstants {
        enum Height {
            static let cell: CGFloat = 56
        }
    }
    
    private let viewModel: ActivityLogViewModel
    private let bag = DisposeBag()
    
    init(viewModel: ActivityLogViewModel) {
        self.viewModel = viewModel
        super.init(viewMaker: ActivityLogView(),
                   analytics: viewModel.analytics,
                   analyticsScreenType: .activityLog)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .babyMonitorDarkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = Localizable.ActivityLog.title
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.customFont(withSize: .body, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setup() {
        navigationItem.leftBarButtonItem = customView.cancelItemButton
        customView.cancelItemButton.target = self
        customView.cancelItemButton.action = #selector(didTouchCancelButton)
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        viewModel.sectionsChangeObservable
            .subscribe { [weak self] _ in
                self?.customView.tableView.reloadData()
            }
        .disposed(by: bag)
        viewModel.baby
            .map { $0.name }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.customView.tableView.reloadData()
            })
        .disposed(by: bag)
    }
    
    @objc
    private func didTouchCancelButton() {
        viewModel.selectCancel()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell() as ActivityLogCell
        viewModel.configure(headerCell: headerCell, for: section)
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GeneralConstants.Height.cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return GeneralConstants.Height.cell
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ActivityLogCell
        viewModel.configure(cell: cell, for: indexPath)
        return cell
    }
}
