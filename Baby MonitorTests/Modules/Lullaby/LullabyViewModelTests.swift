//
//  LullabyViewModelTests.swift
//  Baby MonitorTests
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
import RxBlocking
@testable import BabyMonitor

class LullabyViewModelTests: XCTestCase {

    private var bag = DisposeBag()
    
    override func setUp() {
        bag = DisposeBag()
    }
    
    func testShouldReturnProperSections() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([GeneralSection<Lullaby>].self)
        let babiesRepository = DatabaseRepositoryMock()
        let lullaby = Lullaby(name: "test", identifier: "test", type: .yourLullabies)
        let lullabiesRepository = LullabiesRepositoryMock(currentLullabies: [lullaby])
        let sut = LullabiesViewModel(babyModelController: babiesRepository, lullabiesRepo: lullabiesRepository)
        
        // When
        sut.sections
            .subscribe(observer)
            .disposed(by: bag)
        
        // Then
        let actualTitles = observer.events.first!.value.element!.map { $0.title }
        let bmLibraryLullabies = observer.events.first!.value.element!.map { $0.items }[0]
        let yourLullabies = observer.events.first!.value.element!.map { $0.items }[1]
        XCTAssertEqual(1, observer.events.count)
        XCTAssertEqual([Localizable.Lullabies.bmLibrary, Localizable.Lullabies.yourLullabies], actualTitles)
        XCTAssertEqual(BMLibraryEntry.allLullabies, bmLibraryLullabies)
        XCTAssertEqual([lullaby], yourLullabies)
    }
    
    func testShouldConfigureCell() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let lullabiesRepository = LullabiesRepositoryMock()
        let sut = LullabiesViewModel(babyModelController: babiesRepository, lullabiesRepo: lullabiesRepository)
        let lullaby = Lullaby(name: "lullaby", identifier: "id", type: .bmLibrary)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(cell: cell, for: lullaby)
        
        // Then
        XCTAssertEqual(lullaby.name, cell.mainText)
    }
    
    func testShouldConfigureHeaderCellBmLibrary() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let lullabiesRepository = LullabiesRepositoryMock()
        let sut = LullabiesViewModel(babyModelController: babiesRepository, lullabiesRepo: lullabiesRepository)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(headerCell: cell, for: 0)
        
        // Then
        XCTAssertTrue(cell.isConfiguredAsHeader)
        XCTAssertEqual(LullabiesViewModel.Section.bmLibrary.title, cell.mainText)
    }
    
    func testShouldConfigureHeaderCellForYourLullabies() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let lullabiesRepository = LullabiesRepositoryMock()
        let sut = LullabiesViewModel(babyModelController: babiesRepository, lullabiesRepo: lullabiesRepository)
        let cell = BabyMonitorCellMock()
        
        // When
        sut.configure(headerCell: cell, for: 1)
        
        // Then
        XCTAssertTrue(cell.isConfiguredAsHeader)
        XCTAssertEqual(LullabiesViewModel.Section.yourLullabies.title, cell.mainText)
    }
    
    func testShouldSaveLullabies() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let lullabiesRepository = LullabiesRepositoryMock()
        let lullabies = [Lullaby(name: "test", identifier: "test", type: .yourLullabies),
                         Lullaby(name: "test2", identifier: "test2", type: .yourLullabies)]
        let sut = LullabiesViewModel(babyModelController: babiesRepository, lullabiesRepo: lullabiesRepository)
        
        // When
        sut.save(lullabies: lullabies)
        
        // Then
        XCTAssertEqual(lullabies, try! lullabiesRepository.lullabies.toBlocking().first()!.sorted(by: { rhs, lhs -> Bool in
            rhs.name < lhs.name
        }))
    }
    
    func testShouldReturnCanDeleteOnlyForYourLullabiesSection() {
        // Given
        let babiesRepository = DatabaseRepositoryMock()
        let lullabiesRepository = LullabiesRepositoryMock()
        let sut = LullabiesViewModel(babyModelController: babiesRepository, lullabiesRepo: lullabiesRepository)
        let indexPaths = LullabiesViewModel.Section.allCases.map { IndexPath(row: 0, section: $0.rawValue) }
        let expectedResults = LullabiesViewModel.Section.allCases.map { $0 == .yourLullabies }
        
        // When
        let actualResults = indexPaths.map { sut.canDelete(rowAt: $0) }
        
        // Then
        XCTAssertEqual(expectedResults, actualResults)
    }
    
}
