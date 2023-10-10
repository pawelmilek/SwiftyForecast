import Foundation
@testable import SwiftyForecast

final class TestForecastDAO: ForecastDAO {
    var hasGetForecastResponse = false
    var hasPutForecastResponse = false
    var hasDeleteForecastResponse = false
    var hasDeleteAllForecastResponse = false

    func get(latitude: Double, longitude: Double) -> ForecastResponse? {
        hasGetForecastResponse = true
        return nil
    }

    func put(_ forecast: ForecastResponse) {
        hasPutForecastResponse = true
    }

    func delete(_ forecast: ForecastResponse) throws {
        hasDeleteForecastResponse = true
    }

    func deleteAll() throws {
        hasDeleteAllForecastResponse = true
    }
}
