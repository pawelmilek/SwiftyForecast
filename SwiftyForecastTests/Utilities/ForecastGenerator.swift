@testable import SwiftyForecast

struct ForecastGenerator {
  
  static func generateTimezone() -> String {
    return forecastResponse.timezone
  }
  
  static func generateCurrentForecast() -> CurrentForecastDTO {
    return forecastResponse.currently
  }
  
  static func generateHourlyForecast() -> HourlyForecastDTO {
    return forecastResponse.hourly
  }
  
  static func generateDailyForecast() -> DailyForecastDTO {
    return forecastResponse.daily
  }
}

// MARK: - Private - Generate forecast response from a stub
extension ForecastGenerator {
  
  private static var forecastResponse: ForecastDTO = {
    return ForecastGenerator.generateForecast()!
  }()
  
  private static func generateForecast() -> ForecastDTO? {
    do {
      let data = try JSONFileLoader.loadFile(with: "forecastChicagoStub")
      let result = NetworkResponseParser<ForecastResponse>.parseJSON(data)
      
      switch result {
      case .success(let data):
        let forecastDTO = ModelTranslator().translate(forecast: data)
        return forecastDTO
        
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
      
    } catch {
      debugPrint(error.localizedDescription)
    }
    
    return nil
  }
  
}
