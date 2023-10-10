import Foundation
import RealmSwift

@objcMembers final class HourlyForecast: Object, Decodable {
  dynamic var summary = ""
  dynamic var icon = ""
  dynamic var data = List<HourlyData>()
  
  private enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case data
  }
  
  convenience init(summary: String, icon: String, data: List<HourlyData>) {
    self.init()
    self.summary = summary
    self.icon = icon
    self.data = data
  }
  
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let firstTwentyFourHourForecast = 24
    let summary = try container.decode(String.self, forKey: .summary)
    let icon = try container.decode(String.self, forKey: .icon)
    let data = try Array(container.decode([HourlyData].self, forKey: .data).prefix(firstTwentyFourHourForecast))
    
    let dataList = List<HourlyData>()
    data.forEach {
      dataList.append($0)
    }
    
    self.init(summary: summary, icon: icon, data: dataList)
  }
  
  required init() {
    super.init()
  }
}
