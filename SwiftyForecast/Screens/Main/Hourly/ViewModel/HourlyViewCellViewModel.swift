import Foundation

@MainActor
final class HourlyViewCellViewModel: ObservableObject {
    private(set) var time = ""
    private(set) var iconURL: URL?
    private(set) var temperature = ""

    private let model: HourlyForecastModel
    private let temperatureRenderer: TemperatureRenderer

    init(
        model: HourlyForecastModel,
        temperatureRenderer: TemperatureRenderer = TemperatureRenderer()
    ) {
        self.model = model
        self.temperatureRenderer = temperatureRenderer
        time = model.date.shortTime
        iconURL = WeatherEndpoint.iconLarge(symbol: model.icon).url
        setTemperatureAccordingToUnitNotation(model.temperature)
    }

    private func setTemperatureAccordingToUnitNotation(_ valueInKelvin: Double) {
        let rendered = temperatureRenderer.render(valueInKelvin)
        temperature = rendered.currentFormatted
    }

    func setTemperature() {
        setTemperatureAccordingToUnitNotation(model.temperature)
    }
}
