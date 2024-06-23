import Foundation

@MainActor
final class DailyViewCellViewModel: ObservableObject {
    @Published private(set) var attributedDate = NSAttributedString()
    @Published private(set) var temperature = "--"
    @Published private(set) var iconURL: URL?
    private var model: DailyForecastModel
    private var temperatureFormatterFactory: TemperatureFormatterFactoryProtocol

    init(
        model: DailyForecastModel,
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
    ) {
        self.model = model
        self.temperatureFormatterFactory = temperatureFormatterFactory
    }

    func render() {
        attributedDate = renderMonthWeekday(date: model.date)
        iconURL = WeatherEndpoint.iconLarge(symbol: model.icon).url
        if let current = model.temperature {
            let formatter = temperatureFormatterFactory.make(by: Temperature(current: current))
            temperature = formatter.current()
        }
    }

    private func renderMonthWeekday(date: Date) -> NSAttributedString {
        let completeDate = date.formatted(date: .complete, time: .omitted)
        let splited = completeDate
            .split(separator: ",")
            .dropLast()

        let month = splited.last?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased() ?? ""
        let weekday = splited.first?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased() ?? ""

        let fullDate = ("\(weekday)\r\n\(month)") as NSString
        let weekdayRange = fullDate.range(of: weekday)
        let monthRange = fullDate.range(of: month)

        let attributedString = NSMutableAttributedString(string: fullDate as String)
        attributedString.addAttributes([.font: Style.DailyCell.weekdayFont], range: weekdayRange)
        attributedString.addAttributes([.font: Style.DailyCell.monthFont], range: monthRange)
        return attributedString
    }
}
