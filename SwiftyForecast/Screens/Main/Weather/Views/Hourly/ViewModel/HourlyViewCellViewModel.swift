import Foundation

@MainActor
final class HourlyViewCellViewModel: ObservableObject {
    @Published private(set) var time = ""
    @Published private(set) var iconURL: URL?
    @Published private(set) var temperature = ""
    private let model: HourlyForecastModel
    private let temperatureRenderer: TemperatureRenderer

    init(
        model: HourlyForecastModel,
        temperatureRenderer: TemperatureRenderer
    ) {
        self.model = model
        self.temperatureRenderer = temperatureRenderer
    }

    func render() {
        time = model.date.formatted(date: .omitted, time: .shortened)
        iconURL = WeatherEndpoint.iconLarge(symbol: model.icon).url
        temperature = temperatureRenderer.render(model.temperature).currentFormatted
    }
}
