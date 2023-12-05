import Foundation

extension Bundle {

    var releaseVersionNumber: String {
        let version = infoDictionary?["CFBundleShortVersionString"] as? String
        return version ?? "1.0"
    }

    var buildNumber: String {
        let build = infoDictionary?["CFBundleVersion"] as? String
        return build ?? "1"
    }

}
