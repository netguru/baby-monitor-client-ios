//
//  SettingsViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
@testable import BabyMonitor

class SettingsViewModelTests: XCTestCase {
    
    private var bag = DisposeBag()
    private var showBabiesTap = PublishSubject<Void>()
    private var memoryCleaner = MemoryCleaner()
    private var urlConfiguration = URLConfigurationMock()
    
    override func setUp() {
        showBabiesTap = PublishSubject<Void>()
        bag = DisposeBag()
        memoryCleaner = MemoryCleaner()
        urlConfiguration = URLConfigurationMock()
    }

    func testShouldUpdateCellForChangeServer() {
        // Given
        let exp = expectation(description: "Did called didSelectChangeServer")
        let babiesRepository = DatabaseRepositoryMock()
        let storageServerService = StorageServerServiceMock()
        let sut = SettingsViewModel(babyModelController: babiesRepository, storageServerService: storageServerService, memoryCleaner: memoryCleaner, urlConfiguration: urlConfiguration)
        let cell = BabyMonitorCellMock()
        sut.didSelectChangeServer = { exp.fulfill() }
        
        // When
        sut.configure(cell: cell, for: SettingsViewModel.Cell.changeServer)
        cell.didTap?()
        
        // Then
        waitForExpectations(timeout: 0.1) { _ in
            XCTAssertEqual(Localizable.Settings.changeServer, cell.mainText)
        }
    }
    
    func testShouldUpdateCellForSwitchToServer() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let storageServerService = StorageServerServiceMock()
        let sut = SettingsViewModel(babyModelController: babiesRepository, storageServerService: storageServerService, memoryCleaner: memoryCleaner, urlConfiguration: urlConfiguration)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(cell: cell, for: SettingsViewModel.Cell.switchToServer)
        
        // Then
        XCTAssertEqual(Localizable.Settings.switchToServer, cell.mainText)
    }
    
    func testShouldReturnProperSections() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([GeneralSection<SettingsViewModel.Cell>].self)
        let babiesRepository = DatabaseRepositoryMock()
        let storageServerService = StorageServerServiceMock()
        let sut = SettingsViewModel(babyModelController: babiesRepository, storageServerService: storageServerService, memoryCleaner: memoryCleaner, urlConfiguration: urlConfiguration)
        let expectedSection = [
            GeneralSection<SettingsViewModel.Cell>(title: Localizable.Settings.main, items: [SettingsViewModel.Cell.switchToServer, SettingsViewModel.Cell.changeServer, SettingsViewModel.Cell.sendRecordings, SettingsViewModel.Cell.clearData]),
            GeneralSection<SettingsViewModel.Cell>(title: Localizable.Settings.cryingDetectionMethod, items: [SettingsViewModel.Cell.useML, SettingsViewModel.Cell.useStaticCryingDetection])
        ]
        
        // When
        sut.sections
            .subscribe(observer)
            .disposed(by: bag)
        
        // Then
        XCTAssertRecordedElements(observer.events, [expectedSection])
    }
}
