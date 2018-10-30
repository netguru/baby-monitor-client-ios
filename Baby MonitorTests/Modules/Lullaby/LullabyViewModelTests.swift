//
//  LullabyViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
@testable import BabyMonitor

class LullabyViewModelTests: XCTestCase {

    private var bag = DisposeBag()
    private var showBabiesTap = PublishSubject<Void>()
    
    override func setUp() {
        showBabiesTap = PublishSubject<Void>()
        bag = DisposeBag()
    }
    
    func testShouldForwardSwitchBabyTap() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let babiesRepository = BabiesRepositoryMock()
        let sut = LullabiesViewModel(babyRepo: babiesRepository)
        sut.attachInput(showBabiesTap: ControlEvent(events: showBabiesTap))
        sut.showBabies?
            .subscribe(observer)
            .disposed(by: bag)
        
        // When
        showBabiesTap.onNext(())
        
        // Then
        XCTAssertEqual(1, observer.events.count)
    }
    
    func testShouldReturnProperSections() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([GeneralSection<Lullaby>].self)
        let babiesRepository = BabiesRepositoryMock()
        let sut = LullabiesViewModel(babyRepo: babiesRepository)
        
        // When
        sut.sections
            .subscribe(observer)
            .disposed(by: bag)
        
        // Then
        let actualTitles = observer.events.first!.value.element!.map { $0.title }
        XCTAssertEqual(1, observer.events.count)
        XCTAssertEqual([Localizable.Lullabies.bmLibrary, Localizable.Lullabies.yourLullabies], actualTitles)
    }
    
    func testShouldConfigureCell() {
        // Given
        let babiesRepository = BabiesRepositoryMock()
        let sut = LullabiesViewModel(babyRepo: babiesRepository)
        let lullaby = Lullaby(name: "lullaby")
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(cell: cell, for: lullaby)
        
        // Then
        XCTAssertEqual(lullaby.name, cell.mainText)
    }
    
    func testShouldConfigureHeaderCellBmLibrary() {
        // Given
        let babiesRepository = BabiesRepositoryMock()
        let sut = LullabiesViewModel(babyRepo: babiesRepository)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(headerCell: cell, for: 0)
        
        // Then
        XCTAssertTrue(cell.isConfiguredAsHeader)
        XCTAssertEqual(LullabiesViewModel.Section.bmLibrary.title, cell.mainText)
    }
    
    func testShouldConfigureHeaderCellForYourLullabies() {
        // Given
        let babiesRepository = BabiesRepositoryMock()
        let sut = LullabiesViewModel(babyRepo: babiesRepository)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(headerCell: cell, for: 1)
        
        // Then
        XCTAssertTrue(cell.isConfiguredAsHeader)
        XCTAssertEqual(LullabiesViewModel.Section.yourLullabies.title, cell.mainText)
    }
}
