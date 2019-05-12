struct ForecastGenerator {
  
  static func generateTimezone() -> String {
    return forecastResponse.timezone
  }
  
  static func generateCurrentForecast() -> CurrentForecast {
    return forecastResponse.currently
  }
  
  static func generateHourlyForecast() -> HourlyForecast {
    return forecastResponse.hourly
  }
  
  static func generateDailyForecast() -> DailyForecast {
    return forecastResponse.daily
  }
  
  private static var forecastResponse: ForecastResponse {
    return ForecastGenerator.generateForecast()!
  }
  
  private static func generateForecast() -> ForecastResponse? {
    do {
      let data = try JSONFileLoader.loadFile(with: "forecastChicagoStub")
      let result = Parser<ForecastResponse>.parseJSON(data)
      
      switch result {
      case .success(let data):
        return data
        
      default:
        return nil
      }
      
    } catch {
      return nil
    }
  }
}
