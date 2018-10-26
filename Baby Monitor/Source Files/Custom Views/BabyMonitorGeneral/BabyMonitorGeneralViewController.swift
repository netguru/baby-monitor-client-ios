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

class BabyMonitorGeneralViewController<T>: TypedViewController<BabyMonitorGeneralView>, UITableViewDelegate {

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
        
        viewModel.loadBabies()
    }
    
    private func setupViewModel() {
        viewModel.attachInput?(customView.rx.switchBabiesTap)
        let dataSource = RxTableViewSectionedReloadDataSource<GeneralSection<T>>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(for: indexPath) as BabyMonitorCell
                self.viewModel.configure(cell: cell, for: item)
                return cell
            })
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
        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard viewModel.isBabyMonitorHeaderCellConfigurable else {
            return CGFloat.leastNormalMagnitude
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

// MARK: - BabyRepoObserver
extension BabyMonitorGeneralViewController: BabyRepoObserver {

    func babyRepo(_ service: BabiesRepository, didChangePhotoOf baby: Baby) {
        customView.babyNavigationItemView.setBabyPhoto(baby.photo)
        customView.tableView.reloadData()
    }

    func babyRepo(_ service: BabiesRepository, didChangeNameOf baby: Baby) {
        customView.babyNavigationItemView.setBabyName(baby.name)
        customView.tableView.reloadData()
    }
}
