//
//  ActivityLogViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
@testable import BabyMonitor

class ActivityLogViewModelTests: XCTestCase {

    private var showBabiesTap = PublishSubject<Void>()
    private let bag = DisposeBag()
    
    override func setUp() {
        showBabiesTap = PublishSubject<Void>()
    }
    
    func testShouldConfigureCell() {
        // Given
        let babiesRepository = BabiesRepositoryMock()
        let sut = ActivityLogViewModel(babyRepo: babiesRepository)
        let photo = UIImage(named: "add")
        let baby = Baby(id: "id", name: "name", photo: photo)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(cell: cell, for: baby)

        // Then
        XCTAssertEqual(photo, cell.image)
        XCTAssertNotNil(cell.secondaryText)
        XCTAssertNotNil(cell.mainText)
    }
    
    func testShouldConfigureHeaderCell() {
        // Given
        let babiesRepository = BabiesRepositoryMock()
        let sut = ActivityLogViewModel(babyRepo: babiesRepository)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(headerCell: cell, for: 0)
        
        // Then
        XCTAssertTrue(cell.isConfiguredAsHeader)
        XCTAssertNotNil(cell.mainText)
    }
    
    func testShouldForwardSwitchBabyTap() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        let babiesRepository = BabiesRepositoryMock()
        let sut = ActivityLogViewModel(babyRepo: babiesRepository)
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
        let observer = scheduler.createObserver([GeneralSection<Baby>].self)
        let baby = Baby(id: "id", name: "name", photo: nil)
        let babiesRepository = BabiesRepositoryMock(currentBaby: baby)
        let sut = ActivityLogViewModel(babyRepo: babiesRepository)
        sut.attachInput(showBabiesTap: ControlEvent(events: showBabiesTap))
        
        // When
        sut.sections
            .subscribe(observer)
            .disposed(by: bag)
        
        // Then
        XCTAssertRecordedElements(observer.events, [[GeneralSection<Baby>(title: "", items: [baby])]])
    }
}
