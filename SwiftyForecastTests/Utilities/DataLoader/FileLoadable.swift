import Foundation

protocol FileLoadable: class {
  static func loadFile(with name: String) throws -> Data
}
