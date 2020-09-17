import Foundation

typealias Parameters = [String: String]

protocol WebRequest {
  var baseURL: URL { get }
  var path: String { get }
  var urlRequest: URLRequest { get }
  var parameters: Parameters { get }
}
