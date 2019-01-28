//
//  SettingsViewModel.swift
//  Baby Monitor
//

import RxSwift
import RxCocoa

final class SettingsViewModel: BabyMonitorGeneralViewModelProtocol, BabyMonitorHeaderCellConfigurable {

    private let babyModelController: BabyModelControllerProtocol
    private let storageServerService: StorageServerServiceProtocol
    private let memoryCleaner: MemoryCleanerProtocol
    private let urlConfiguration: URLConfiguration

    private let bag = DisposeBag()

    typealias DataType = Cell
    
    enum Section: Int, CaseIterable {
        case main = 0
        case cryingDetection = 1
        
        var title: String {
            switch self {
            case .main:
                return Localizable.Settings.main
            case .cryingDetection:
                return Localizable.Settings.cryingDetectionMethod
            }
        }
    }
    
    // MARK: - Coordinator callback
    var didSelectChangeServer: (() -> Void)?
    var didSelectClearData: (() -> Void)?
    
    lazy var baby: Observable<Baby> = babyModelController.babyUpdateObservable
    
    private(set) lazy var sections: Observable<[GeneralSection<Cell>]> = {
        let mainSection = Observable.just(GeneralSection(title: Section.main.title, items: [Cell.switchToServer, Cell.changeServer, Cell.sendRecordings, Cell.clearData]))
        let detectionSection = Observable.just(GeneralSection(title: Section.cryingDetection.title, items: [Cell.useML, Cell.useStaticCryingDetection]))
        return Observable.combineLatest(mainSection, detectionSection, resultSelector: { mainSection, detectionSection -> [GeneralSection<Cell>] in
            return [mainSection, detectionSection]
        }).concat(Observable.never())
    }()

    enum Cell: CaseIterable, Equatable {
        case switchToServer
        case changeServer
        case useML
        case useStaticCryingDetection
        case sendRecordings
        case clearData
    }

    init(babyModelController: BabyModelControllerProtocol, storageServerService: StorageServerServiceProtocol, memoryCleaner: MemoryCleanerProtocol, urlConfiguration: URLConfiguration) {
        self.babyModelController = babyModelController
        self.memoryCleaner = memoryCleaner
        self.urlConfiguration = urlConfiguration
        self.storageServerService = storageServerService
    }

    // MARK: - Internal functions
    func attachInput(babyName: Observable<String>) {
        babyName.subscribe(onNext: { [weak self] name in
            self?.babyRepo.setCurrentName(name)
        })
        .disposed(by: bag)
    }
    
    func configure(cell: BabyMonitorCellProtocol, for data: Cell) {
        cell.type = .settings
        switch data {
        case Cell.switchToServer:
            //TODO: mock for now, ticket: https://netguru.atlassian.net/browse/BM-67
            cell.update(mainText: Localizable.Settings.switchToServer)
        case Cell.changeServer:
            cell.update(mainText: Localizable.Settings.changeServer)
            cell.didTap = { [weak self] in
                self?.didSelectChangeServer?()
            }
        case Cell.useML:
            cell.update(mainText: Localizable.Settings.useML)
            cell.showCheckmark(true)
        case Cell.useStaticCryingDetection:
            cell.update(mainText: Localizable.Settings.useStaticCryingDetection)
        case Cell.sendRecordings:
            cell.update(mainText: Localizable.Settings.sendRecordingsToServer)
            cell.didTap = { [weak self] in
                self?.storageServerService.uploadRecordingsToDatabase()
            }
        case Cell.clearData:
            cell.update(mainText: Localizable.Settings.clearData)
            cell.didTap = { [weak self] in
                self?.didSelectClearData?()
            }
        }
    }
    
    func configure(headerCell: BabyMonitorCellProtocol, for section: Int) {
        guard let typedSection = Section(rawValue: section) else {
            return
        }
        headerCell.configureAsHeader()
        switch typedSection {
        case Section.main:
            headerCell.update(mainText: Section.main.title)
        case Section.cryingDetection:
            headerCell.update(mainText: Section.cryingDetection.title)
        }
    }
    
    func clearAllDataForNoneState() {
        babyModelController.removeAllData()
        memoryCleaner.cleanMemory()
        urlConfiguration.url = nil
        UserDefaults.appMode = .none
    }
}
