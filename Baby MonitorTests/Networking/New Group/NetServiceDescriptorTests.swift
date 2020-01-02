//
//  NetServiceDescriptorTests.swift
//  Baby MonitorTests
//

@testable import BabyMonitor
import XCTest

class NetServiceDescriptorTests: XCTestCase {

    func testShouldRemoveServiceNameForDeviceName() {
        let name = "Device name"
        let sut = NetServiceDescriptor(name: name + Constants.netServiceName, ip: "", port: "")
        XCTAssertEqual(sut.deviceName, name)
    }

    func testShouldRemoveServiceNameForDeviceNameAndReturnUnknownForEmptyName() {
        let name = ""
        let sut = NetServiceDescriptor(name: name + Constants.netServiceName, ip: "", port: "")
        XCTAssertEqual(sut.deviceName, Localizable.Onboarding.Pairing.unknownDevice)
    }
}
