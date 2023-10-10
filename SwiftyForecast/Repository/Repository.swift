import UIKit

protocol Repository {
    func fetch(latitude: Double, longitude: Double) async throws -> WeatherModel
    func fetchIcon(_ iconCode: String) async throws -> UIImage
    func fetchLargeIcon(_ iconCode: String) async throws -> UIImage
}
