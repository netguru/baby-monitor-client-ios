//
//  SpecifyDeviceOnboardingViewModelTests.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import XCTest

class SpecifyDeviceOnboardingViewModelTests: XCTestCase {
    
    //Given
    var sut = SpecifyDeviceOnboardingViewModel()
    
    override func setUp() {
        sut = SpecifyDeviceOnboardingViewModel()
    }
    
    func testShouldNotifyAboutSelectingParent() {
        //Given
        let exp = expectation(description: "Should notify about selecting parent")
        sut.didSelectParent = {
            exp.fulfill()
        }
        
        //When
        sut.selectParent()
        
        //Then
        wait(for: [exp], timeout: 0.1)
    }
    
    func testShouldNotifyAboutSelectingBaby() {
        //Given
        let exp = expectation(description: "Should notify about selecting baby")
        sut.didSelectBaby = {
            exp.fulfill()
        }
        
        //When
        sut.selectBaby()
        
        //Then
        wait(for: [exp], timeout: 0.1)
    }
}
