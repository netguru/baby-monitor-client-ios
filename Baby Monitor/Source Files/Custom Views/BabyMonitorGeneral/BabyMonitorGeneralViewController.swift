//
//  SwitchBabyViewController.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxDataSources

enum BabyMonitorGeneralViewType {
    case switchBaby
    case activityLog
    case lullaby
    case settings
}

private enum GeneralConstants {
    enum Height {
        static let cell: CGFloat = 56
    }
}

class BabyMonitorGeneralViewController<T: Equatable>: TypedViewController<BabyMonitorGeneralView>, UITableViewDelegate {

    private let viewModel: AnyBabyMonitorGeneralViewModelProtocol<T>
    private let viewType: BabyMonitorGeneralViewType
    private let bag = DisposeBag()

    init(viewModel: AnyBabyMonitorGeneralViewModelProtocol<T>, type: BabyMonitorGeneralViewType) {
        self.viewModel = viewModel
        self.viewType = type
        super.init(viewMaker: BabyMonitorGeneralView(type: type))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setup()
    }

    // MARK: - Private functions
    private func setup() {
        customView.tableView.delegate = self

        switch viewType {
        case .activityLog, .lullaby, .settings:
            navigationItem.titleView = customView.babyNavigationItemView
        case .switchBaby:
            view.backgroundColor = .clear
        }        
    }
    
    private func setupViewModel() {
        let dataSource = RxTableViewSectionedReloadDataSource<GeneralSection<T>>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(for: indexPath) as BabyMonitorCell
                self.viewModel.configure(cell: cell, for: item)
                return cell
            })
        dataSource.canEditRowAtIndexPath = { [unowned self] _, indexPath in
            return self.viewModel.canDelete?(indexPath) ?? false
        }
        viewModel.sections
            .bind(to: customView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        viewModel.baby
            .map { $0.name }
            .distinctUntilChanged()
            .bind(to: customView.babyNavigationItemView.rx.babyName)
            .disposed(by: bag)
        viewModel.baby
            .map { $0.photo }
            .distinctUntilChanged()
            .bind(to: customView.babyNavigationItemView.rx.babyPhoto)
            .disposed(by: bag)
        customView.tableView.rx.modelDeleted(T.self)
            .subscribe(onNext: { [unowned self] model in
                self.viewModel.delete(model: model)
            })
            .disposed(by: bag)
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BabyMonitorCell,
            let cellSelectableViewModel = viewModel as? BabyMonitorCellSelectable else {
                return
        }

        cellSelectableViewModel.select(cell: cell)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel.isBabyMonitorHeaderCellConfigurable else {
            return nil
        }
        
        let headerCell = tableView.dequeueReusableCell() as BabyMonitorCell
        viewModel.configure?(headerCell, section)
        return headerCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GeneralConstants.Height.cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard viewModel.isBabyMonitorHeaderCellConfigurable else {
            return CGFloat.leastNormalMagnitude
        }
        return GeneralConstants.Height.cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
