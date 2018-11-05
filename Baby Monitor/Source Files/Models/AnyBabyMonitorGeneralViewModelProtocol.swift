//
//  AnyBabyMonitorGeneralViewModelProtocol.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa

private extension BabyMonitorGeneralViewModelProtocol {
    func getShowBabies() -> Observable<Void>? {
        return showBabies
    }
    
    func getBaby() -> Observable<Baby> {
        return baby
    }
    
    func getSections() -> Observable<[GeneralSection<DataType>]> {
        return sections
    }
}

final class AnyBabyMonitorGeneralViewModelProtocol<ConcreteDataType: Equatable>: BabyMonitorGeneralViewModelProtocol {
    
    var showBabies: Observable<Void>? {
        return _getShowBabies()
    }
    private let _getShowBabies: () -> Observable<Void>?
    
    var baby: Observable<Baby> {
        return _getBaby()
    }
    private let _getBaby: () -> Observable<Baby>
    
    private let _delete: ((_ model: ConcreteDataType) -> Void)?
    
    var sections: Observable<[GeneralSection<ConcreteDataType>]> {
        return _getSections()
    }
    private let _getSections: () -> Observable<[GeneralSection<ConcreteDataType>]>
    
    private let _configure: (BabyMonitorCellProtocol, ConcreteDataType) -> Void
    
    // MARK: - BabiesViewSelectable thunk
    let attachInput: ((_ showBabiesTap: ControlEvent<Void>) -> Void)?
    // MARK: - BabyMonitorHeaderCellConfigurable thunk
    let configure: ((_ headerCell: BabyMonitorCell, _ section: Int) -> Void)?
    let isBabyMonitorHeaderCellConfigurable: Bool
    // MARK: - BabyMonitorCellDeletable thunk
    let canDelete: ((_ indexPath: IndexPath) -> Bool)?
    
    required init<ViewModelProtocol: BabyMonitorGeneralViewModelProtocol>(viewModel: ViewModelProtocol) where ViewModelProtocol.DataType == ConcreteDataType {
        self._getShowBabies = viewModel.getShowBabies
        self._getBaby = viewModel.getBaby
        self._getSections = viewModel.getSections
        self._configure = viewModel.configure
        self._delete = viewModel.delete
        if let viewModel = viewModel as? BabiesViewSelectable {
            self.attachInput = viewModel.attachInput
        } else {
            self.attachInput = nil
        }
        if let viewModel = viewModel as? BabyMonitorHeaderCellConfigurable {
            self.configure = viewModel.configure
            self.isBabyMonitorHeaderCellConfigurable = true
        } else {
            self.configure = nil
            self.isBabyMonitorHeaderCellConfigurable = false
        }
        if let viewModel = viewModel as? BabyMonitorCellDeletable {
            self.canDelete = viewModel.canDelete
        } else {
            self.canDelete = nil
        }
    }
    
    func configure(cell: BabyMonitorCellProtocol, for data: ConcreteDataType) {
        _configure(cell, data)
    }
    
    func delete(model: ConcreteDataType) {
        _delete?(model)
    }
}
