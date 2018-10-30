//
//  SwitchBabyViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
@testable import BabyMonitor

class SwitchBabyViewModelTests: XCTestCase {
    
    private var bag = DisposeBag()
    
    override func setUp() {
        bag = DisposeBag()
    }
    
    func testShouldReturnProperSections() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([GeneralSection<SwitchBabyViewModel.Cell>].self)
        let baby = Baby(id: "id", name: "name", photo: nil)
        let babiesRepository = BabiesRepositoryMock(currentBaby: baby)
        let sut = SwitchBabyViewModel(babyRepo: babiesRepository)
        
        // When
        sut.sections
            .subscribe(observer)
            .disposed(by: bag)
        
        // Then
        XCTAssertRecordedElements(observer.events, [[GeneralSection<SwitchBabyViewModel.Cell>(title: "", items: [SwitchBabyViewModel.Cell.baby(baby), SwitchBabyViewModel.Cell.addAnother])]])
    }
    
    func testShouldConfigureCellForBaby() {
        // Given
        let baby = Baby(id: "id", name: "name", photo: UIImage(named: "add"))
        let babiesRepository = BabiesRepositoryMock()
        let sut = SwitchBabyViewModel(babyRepo: babiesRepository)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(cell: cell, for: .baby(baby))
        
        // Then
        XCTAssertEqual(baby.name, cell.mainText)
        XCTAssertEqual(baby.photo, cell.image)
    }
}
