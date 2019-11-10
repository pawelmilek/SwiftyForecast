import Foundation

final class Path {
  static let groupIdentifier = "group.com.pawelmilek.Swifty-Forecast"
  
  static func inLibrary(_ name: String) throws -> URL {
    return try FileManager.default
      .url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(name)
  }
  
  static func inDocuments(_ name: String) throws -> URL {
    return try FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(name)
  }
  
  static func inMainBundle(_ name: String) throws -> URL {
    guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
      throw PathError.notFound
    }
    return url
  }
  
  static func inSharedContainer(_ name: String) throws -> URL {
    guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Path.groupIdentifier) else {
      throw PathError.containerNotFound(identifier: Path.groupIdentifier)
    }
    return url.appendingPathComponent(name)
  }
  
  static func documents() throws -> URL {
    return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
  }
}
