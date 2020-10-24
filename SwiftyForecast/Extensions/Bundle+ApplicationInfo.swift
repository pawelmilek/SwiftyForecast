import Foundation

extension Bundle {

  var releaseVersionNumber: String {
    let version = infoDictionary?["CFBundleShortVersionString"] as? String
    return version ?? "1.0.0"
  }
  
  var buildNumber: String {
    let build = infoDictionary?["CFBundleVersion"] as? String
    return build ?? "1"
  }
  
  var applicationName: String {
    return infoDictionary?["CFBundleDisplayName"] as? String ?? "RetailNavigator"
  }
  
  var applicationReleaseDate: String {
    return infoDictionary?["ApplicationReleaseDate"] as? String ?? Date().description
  }
  
  var applicationReleaseNumber: Int {
    return infoDictionary?["ApplicationReleaseNumber"] as? Int ?? 0
  }
  
  var identifierSuffix: String {
    return infoDictionary?["BundleIdentifierSuffix"] as? String ?? ""
  }
  
}
