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

final class AnyBabyMonitorGeneralViewModelProtocol<ConcreteDataType>: BabyMonitorGeneralViewModelProtocol {
    
    var showBabies: Observable<Void>? {
        return _getShowBabies()
    }
    private let _getShowBabies: () -> Observable<Void>?
    
    var baby: Observable<Baby> {
        return _getBaby()
    }
    private let _getBaby: () -> Observable<Baby>
    
    var sections: Observable<[GeneralSection<ConcreteDataType>]> {
        return _getSections()
    }
    private let _getSections: () -> Observable<[GeneralSection<ConcreteDataType>]>
    
    private let _configure: (BabyMonitorCell, ConcreteDataType) -> Void
    
    // MARK: - BabiesViewSelectable thunk
    let attachInput: ((_ showBabiesTap: ControlEvent<Void>) -> Void)?
    // MARK: - BabyMonitorHeaderCellConfigurable thunk
    let configure: ((_ headerCell: BabyMonitorCell, _ section: Int) -> Void)?
    let isBabyMonitorHeaderCellConfigurable: Bool
    
    required init<ViewModelProtocol: BabyMonitorGeneralViewModelProtocol>(viewModel: ViewModelProtocol) where ViewModelProtocol.DataType == ConcreteDataType {
        self._getShowBabies = viewModel.getShowBabies
        self._getBaby = viewModel.getBaby
        self._getSections = viewModel.getSections
        self._configure = viewModel.configure
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
    }
    
    func configure(cell: BabyMonitorCell, for data: ConcreteDataType) {
        _configure(cell, data)
    }
    
    func loadBabies() {
        
    }
}
