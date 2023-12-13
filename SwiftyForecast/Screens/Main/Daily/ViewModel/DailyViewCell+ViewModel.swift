import Foundation

extension DailyViewCell {
    @MainActor
    final class ViewModel: ObservableObject {
        private(set) var attributedDate: NSAttributedString
        private(set) var temperature: String = ""
        private(set) var iconURL: URL?

        private let model: DailyForecastModel
        private let temperatureRenderer: TemperatureRenderer

        init(
            model: DailyForecastModel,
            temperatureRenderer: TemperatureRenderer = TemperatureRenderer()
        ) {
            self.model = model
            self.temperatureRenderer = temperatureRenderer
            attributedDate = DailyDateRenderer.render(model.date)
            iconURL = WeatherEndpoint.iconLarge(symbol: model.icon).url
            setTemperatureAccordingToUnitNotation(model.temperature)
        }

        private func setTemperatureAccordingToUnitNotation(_ valueInKelvin: Double) {
            let rendered = temperatureRenderer.render(valueInKelvin)
            temperature = rendered.current
        }

        func setTemperature() {
            setTemperatureAccordingToUnitNotation(model.temperature)
        }
    }
}
