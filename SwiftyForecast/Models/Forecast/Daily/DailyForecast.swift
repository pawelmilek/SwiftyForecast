import RealmSwift

@objcMembers final class DailyForecast: Object, Decodable {
  dynamic var summary = ""
  dynamic var icon = ""
  dynamic var data = List<DailyData>()
  
  private enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case data
  }
  
  convenience init(summary: String, icon: String, data: List<DailyData>) {
    self.init()
    self.summary = summary
    self.icon = icon
    self.data = data
  }
  
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let summary = try container.decode(String.self, forKey: .summary)
    let icon = try container.decode(String.self, forKey: .icon)
    let data = try container.decode([DailyData].self, forKey: .data)
    let dataList = List<DailyData>()
    data.forEach {
      dataList.append($0)
    }
    
    self.init(summary: summary, icon: icon, data: dataList)
  }
  
  required init() {
    super.init()
  }
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
