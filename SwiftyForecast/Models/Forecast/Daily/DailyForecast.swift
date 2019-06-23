struct DailyForecast {
  let summary: String
  let icon: String
  private let data: [DailyData]
}

extension DailyForecast {
  var numberOfDays: Int {
    let currentDay = 1
    return data.count - currentDay
  }
  
  var sevenDaysData: [DailyData] {
    let sevenDaysData = Array(data.dropFirst())
    return sevenDaysData
  }
  
  var currentDayData: DailyData? {
    return data.first
  }
}

// MARK: - Decodable protocol
extension DailyForecast: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case data
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.summary = try container.decode(String.self, forKey: .summary)
    self.icon = try container.decode(String.self, forKey: .icon)
    self.data = try container.decode([DailyData].self, forKey: .data)
  }
  
}
