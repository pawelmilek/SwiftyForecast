import Foundation

@MainActor
final class HourlyViewCellViewModel: ObservableObject {
    @Published private(set) var time = ""
    @Published private(set) var iconURL: URL?
    @Published private(set) var temperature = "--"
    private let model: HourlyForecastModel
    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol

    init(
        model: HourlyForecastModel,
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
    ) {
        self.model = model
        self.temperatureFormatterFactory = temperatureFormatterFactory
    }

    func render() {
        time = model.date.formatted(date: .omitted, time: .shortened)
        iconURL = WeatherEndpoint.iconLarge(symbol: model.icon).url
        if let current = model.temperature {
            let formatter = temperatureFormatterFactory.make(by: Temperature(current: current))
            temperature = formatter.current()
        }
    }
}
