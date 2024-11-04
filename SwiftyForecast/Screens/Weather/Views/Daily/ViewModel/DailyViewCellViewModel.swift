import Foundation
import SwiftUI

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
        iconURL = OpenWeatherEndpoint.iconLarge(symbol: model.icon).url
        if let current = model.temperature {
            let formatter = temperatureFormatterFactory.make(by: Temperature(current: current))
            temperature = formatter.current()
        }
    }

    private func renderMonthWeekday(date: Date) -> NSAttributedString {
        let weekday = date.formatted(.dateTime.weekday(.wide)).localizedLowercase
        let twoDigitNumericDay = date.formatted(.dateTime.day(.twoDigits))
        let month = date.formatted(.dateTime.month(.wide))
        let monthWithDigits = "\(month) \(twoDigitNumericDay)".localizedLowercase

        let fullDate = ("\(weekday)\r\n\(monthWithDigits)") as NSString
        let weekdayRange = fullDate.range(of: weekday)
        let monthRange = fullDate.range(of: monthWithDigits)

        let attributedString = NSMutableAttributedString(string: fullDate as String)

        // TODO: Remove SwiftUI dependency!
        let weekdayFont = UIFont.preferredFont(for: .subheadline, weight: .bold, design: .monospaced)
        let monthFont = UIFont.preferredFont(for: .caption1, weight: .light, design: .monospaced)

        attributedString.addAttributes([.font: weekdayFont], range: weekdayRange)
        attributedString.addAttributes([.font: monthFont], range: monthRange)
        return attributedString
    }
}
