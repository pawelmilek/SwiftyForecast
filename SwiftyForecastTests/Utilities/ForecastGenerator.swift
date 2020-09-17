@testable import SwiftyForecast

struct ForecastGenerator {
  private static var forecastResponse: ForecastDTO = {
    return ModelTranslator().translate(forecast: ForecastGenerator.generateForecast()!)!
  }()
  
  static func generateForecast() -> ForecastResponse? {
    do {
      let data = try JSONFileLoader.loadFile(with: "forecastChicagoStub")
      let result = NetworkResponseParser<ForecastResponse>.parseJSON(data)
      
      switch result {
      case .success(let data):
        return data
        
      case .failure(let error):
        debugPrint(error.localizedDescription)
      }
      
    } catch {
      debugPrint(error.localizedDescription)
    }
    
    return nil
  }
  
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

