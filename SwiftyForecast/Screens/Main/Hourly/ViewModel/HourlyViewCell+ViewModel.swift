import Foundation

extension HourlyViewCell {
    @MainActor
    final class ViewModel: ObservableObject {
        private(set) var time = ""
        private(set) var iconURL: URL?
        private(set) var temperature = ""

        private let model: HourlyForecastModel
        private let temperatureVolumeFactory: TemperatureFormatterFactoryProtocol
        private let notationController: NotationController

        init(
            model: HourlyForecastModel,
            temperatureVolumeFactory: TemperatureFormatterFactoryProtocol = TemperatureFormatterFactory(),
            notationController: NotationController = NotationController()
        ) {
            self.model = model
            self.temperatureVolumeFactory = temperatureVolumeFactory
            self.notationController = notationController
            time = model.date.shortTime
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
