//
//  BabyMonitorGeneralViewModelProtocol.swift
//  Baby Monitor
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol BabyMonitorGeneralViewModelProtocol: AnyObject {
    
    associatedtype DataType
    
    var showBabies: Observable<Void>? { get }
    
    var baby: Observable<Baby> { get }
    
    var sections: Observable<[GeneralSection<DataType>]> { get }
    func configure(cell: BabyMonitorCell, for data: DataType)
}
