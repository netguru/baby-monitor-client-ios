//
//  BabyMonitorGeneralViewModelProtocol.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol BabyMonitorGeneralViewModelProtocol: AnyObject where DataType: Equatable {
    
    associatedtype DataType
    
    var showBabies: Observable<Void>? { get }
    
    var baby: Observable<Baby> { get }
    
    var sections: Observable<[GeneralSection<DataType>]> { get }
    func configure(cell: BabyMonitorCellProtocol, for data: DataType)
}
