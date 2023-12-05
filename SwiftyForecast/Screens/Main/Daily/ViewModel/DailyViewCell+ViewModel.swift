import Foundation

extension DailyViewCell {
    @MainActor
    final class ViewModel: ObservableObject {
        private(set) var attributedDate: NSAttributedString
        private(set) var temperature: String = ""
        private(set) var iconURL: URL?

        private let model: DailyForecastModel
        private let temperatureVolumeFactory: TemperatureFormatterFactoryProtocol
        private let notationController: NotationController

        init(
            model: DailyForecastModel,
            temperatureVolumeFactory: TemperatureFormatterFactoryProtocol = TemperatureFormatterFactory(),
            notationController: NotationController = NotationController()
        ) {
            self.model = model
            self.temperatureVolumeFactory = temperatureVolumeFactory
            self.notationController = notationController
            attributedDate = DailyDateRenderer.render(model.date)
            iconURL = WeatherEndpoint.iconLarge(symbol: model.icon).url
            setTemperatureAccordingToUnitNotation(model.temperature)
        }

        private func setTemperatureAccordingToUnitNotation(_ valueInKelvin: Double) {
            let temperatureVolume = temperatureVolumeFactory.make(
                by: notationController.temperatureNotation,
                valueInKelvin: valueInKelvin
            )

            temperature = temperatureVolume.currentFormatted
        }

        func setTemperature() {
            setTemperatureAccordingToUnitNotation(model.temperature)
        }
    }
}
