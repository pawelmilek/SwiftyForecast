import Foundation

extension Bundle {
    var applicationName: String {
        guard let infoDictionary = infoDictionary else { return "" }
        if let displayName = infoDictionary["CFBundleDisplayName"] as? String {
            return displayName
        } else if let name = infoDictionary["CFBundleName"] as? String {
            return name
        } else {
            return "Unknown"
        }
   }

    var versionNumber: String {
        let version = infoDictionary?["CFBundleShortVersionString"] as? String
        return version ?? "No app version"
    }

    var buildNumber: String {
        let build = infoDictionary?["CFBundleVersion"] as? String
        return build ?? "No app build version"
    }

    var minimumOSVersion: String {
        let osVersion = infoDictionary?["MinimumOSVersion"] as? String
        return osVersion ?? "Unknown"
    }
}
