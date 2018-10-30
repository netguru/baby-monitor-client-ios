//
//  BabyMonitorGeneralViewModelProtocol.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol BabyMonitorGeneralViewModelProtocol: AnyObject where DataType: Equatable {
    
    /// Data type for sections data
    associatedtype DataType
    
    /// Observable emitting show babies events
    var showBabies: Observable<Void>? { get }
    
    /// Observable emitting current baby
    var baby: Observable<Baby> { get }
    
    /// Observable emitting sections of data
    var sections: Observable<[GeneralSection<DataType>]> { get }

    /// Configures cell with provided data
    ///
    /// - Parameters:
    ///   - cell: Cell to configure
    ///   - data: Data to configure cell with
    func configure(cell: BabyMonitorCellProtocol, for data: DataType)
}
