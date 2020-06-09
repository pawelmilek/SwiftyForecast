import Foundation

protocol FileLoadable: AnyObject {
  static func loadFile(with name: String) throws -> Data
}
