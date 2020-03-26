import Foundation

protocol AppVersionProvider {

    func getAppVersion() -> String
    func getAppVersionWithBuildNumber() -> String
}

class DefaultAppVersionProvider: AppVersionProvider {

    lazy var bundleDataProvider: BundleDataProvider = Bundle.main

    func getAppVersion() -> String {
        return bundleDataProvider.bundleVersion
    }

    func getAppVersionWithBuildNumber() -> String {
        let appVersion = getAppVersion()
        let buildNumber = bundleDataProvider.buildNumber
        return "\(appVersion) (\(buildNumber))"
    }
}

protocol BundleDataProvider: AnyObject {
    var buildNumber: String { get }
    var bundleVersion: String { get }
}

extension Bundle: BundleDataProvider { }
