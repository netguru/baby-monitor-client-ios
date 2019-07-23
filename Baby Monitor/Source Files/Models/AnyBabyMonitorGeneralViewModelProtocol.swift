//
//  AnyBabyMonitorGeneralViewModelProtocol.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa

private extension BabyMonitorGeneralViewModelProtocol {
    
    func getBaby() -> Observable<Baby> {
        return baby
    }
    
    func getSections() -> Observable<[GeneralSection<DataType>]> {
        return sections
    }
}

final class AnyBabyMonitorGeneralViewModelProtocol<ConcreteDataType: Equatable>: BabyMonitorGeneralViewModelProtocol {
        
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
    
    // MARK: - BabyMonitorHeaderCellConfigurable thunk
    let configure: ((_ headerCell: BabyMonitorCell, _ section: Int) -> Void)?
    let isBabyMonitorHeaderCellConfigurable: Bool
    // MARK: - BabyMonitorCellDeletable thunk
    let canDelete: ((_ indexPath: IndexPath) -> Bool)?
    
    required init<ViewModelProtocol: BabyMonitorGeneralViewModelProtocol>(viewModel: ViewModelProtocol) where ViewModelProtocol.DataType == ConcreteDataType {
        self._getBaby = viewModel.getBaby
        self._getSections = viewModel.getSections
        self._configure = viewModel.configure
        self._delete = viewModel.delete
        self.configure = (viewModel as? BabyMonitorHeaderCellConfigurable)?.configure
        self.isBabyMonitorHeaderCellConfigurable = (viewModel as? BabyMonitorHeaderCellConfigurable) != nil
        self.canDelete = (viewModel as? BabyMonitorCellDeletable)?.canDelete
    }
    
    func configure(cell: BabyMonitorCellProtocol, for data: ConcreteDataType) {
        _configure(cell, data)
    }
    
    func delete(model: ConcreteDataType) {
        _delete?(model)
    }
}
