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
    private var bag = DisposeBag()
    
    override func setUp() {
        showBabiesTap = PublishSubject<Void>()
        bag = DisposeBag()
    }
    
    func testShouldConfigureCell() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let sut = ActivityLogViewModel(databaseRepository: babiesRepository)
        let photo = UIImage(named: "add")
        let activityLogEvent = ActivityLogEvent(mode: .cryingEvent)
        let baby = Baby(id: "id", name: "name", photo: photo)
        babiesRepository.save(baby: baby)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(cell: cell, for: activityLogEvent)

        // Then
        XCTAssertEqual(photo, cell.image)
        XCTAssertNotNil(cell.secondaryText)
        XCTAssertNotNil(cell.mainText)
    }
    
    func testShouldConfigureHeaderCell() {
        // Given
        let disposeBag = DisposeBag()
        let babiesRepository = DatabaseRepositoryMock()
        babiesRepository.save(activityLogEvent: ActivityLogEvent(mode: .cryingEvent))
        let sut = ActivityLogViewModel(databaseRepository: babiesRepository)
        sut.sections.subscribe(onNext: { _ in
            
        })
        .disposed(by: disposeBag)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(headerCell: cell, for: 0)
        
        // Then
        XCTAssertTrue(cell.isConfiguredAsHeader)
        XCTAssertNotNil(cell.mainText)
    }
    
    func testShouldNotFillHeaderCellMainText() {
        // Given
        let disposeBag = DisposeBag()
        let babiesRepository = DatabaseRepositoryMock()
        let sut = ActivityLogViewModel(databaseRepository: babiesRepository)
        sut.sections.subscribe(onNext: { _ in
        })
            .disposed(by: disposeBag)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(headerCell: cell, for: 0)
        
        // Then
        XCTAssertTrue(cell.isConfiguredAsHeader)
        XCTAssertNil(cell.mainText)
    }
    
    func testShouldGenerateProperSections() {
        // Given
        let disposeBag = DisposeBag()
        let babiesRepository = DatabaseRepositoryMock()
        let yesterdayCryingLogEvent = ActivityLogEvent(mode: .cryingEvent, date: Date.yesterday)
        let todayCryingLogEvent = ActivityLogEvent(mode: .cryingEvent, date: Date())
        babiesRepository.save(activityLogEvent: yesterdayCryingLogEvent)
        babiesRepository.save(activityLogEvent: todayCryingLogEvent)
        let expectedSections = [
            GeneralSection<ActivityLogEvent>(title: "", items: [yesterdayCryingLogEvent]),
            GeneralSection<ActivityLogEvent>(title: "", items: [todayCryingLogEvent])
        ]
        let sut = ActivityLogViewModel(databaseRepository: babiesRepository)
        var resultSections: [GeneralSection<ActivityLogEvent>] = []
        // When
        sut.sections.subscribe(onNext: { sections in
            resultSections = sections
        })
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(expectedSections, resultSections)
    }
}
