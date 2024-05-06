import Foundation
import Combine

@MainActor
final class DailyViewCellViewModel: ObservableObject {
    @Published private(set) var attributedDate = NSAttributedString()
    @Published private(set) var temperature = ""
    @Published private(set) var iconURL: URL?
    @Published private var model: DailyForecastModel
    @Published private var temperatureRenderer: TemperatureRenderer
    private var cancellables = Set<AnyCancellable>()

    init(
        model: DailyForecastModel,
        temperatureRenderer: TemperatureRenderer
    ) {
        self.model = model
        self.temperatureRenderer = temperatureRenderer
        subscribePublishers()
    }

    private func subscribePublishers() {
        $model
            .combineLatest($temperatureRenderer)
            .sink { [weak self] model, temperatureRenderer in
                guard let self else { return }
                attributedDate = renderMonthWeekday(date: model.date)
                iconURL = WeatherEndpoint.iconLarge(symbol: model.icon).url

                let currentFormatted = temperatureRenderer.render(model.temperature).currentFormatted
                temperature = currentFormatted

            }
            .store(in: &cancellables)
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
