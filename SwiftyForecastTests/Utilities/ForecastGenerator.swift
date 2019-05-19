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
}

// MARK: - Private - Generate forecast response from a stub
extension ForecastGenerator {
  
  private static var forecastResponse: ForecastResponse {
    return ForecastGenerator.generateForecast()!
  }
  
  private static func generateForecast() -> ForecastResponse? {
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
  
}
