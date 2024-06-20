import Foundation

protocol WeatherParser {
    func parse(current: CurrentWeatherResponse) -> WeatherModel
    func parse(forecast: ForecastWeatherResponse) -> ForecastWeatherModel
}

struct ResponseParser: WeatherParser {
    func parse(current: CurrentWeatherResponse) -> WeatherModel {
        guard let currentCondition = current.conditions.first else { fatalError() }

        let currentDate = Date(timeIntervalSince1970: TimeInterval(current.dateTimeUnix))
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(current.metadata.sunrise))
        let sunsetDate = Date(timeIntervalSince1970: TimeInterval(current.metadata.sunset))
        let temperature = Temperature(
            current: current.main.temp,
            min: current.main.tempMin,
            max: current.main.tempMax
        )
        let condition = ConditionModel(
            id: currentCondition.id,
            iconCode: currentCondition.icon,
            name: currentCondition.main,
            description: currentCondition.description
        )

        let currentWeatherModel = WeatherModel(
            date: currentDate,
            temperature: temperature,
            condition: condition,
            humidity: current.main.humidity,
            pressure: current.main.pressure,
            windSpeed: current.wind.speed,
            sunrise: sunriseDate,
            sunset: sunsetDate
        )

        return currentWeatherModel
    }

    func parse(forecast: ForecastWeatherResponse) -> ForecastWeatherModel {
        let hourlyForecastModels = forecast.data.map {
            HourlyForecastModel(
                date: Date(timeIntervalSince1970: TimeInterval($0.dateTimeUnix)),
                temperature: $0.main.temp,
                icon: $0.conditions.first!.icon
            )
        }

        let dailyForecastModels = groupAndFilterOutTodayDate(forecast: forecast)
        let forecastWeatherModel = ForecastWeatherModel(
            hourly: hourlyForecastModels,
            daily: dailyForecastModels
        )

        return forecastWeatherModel
    }

    private func groupAndFilterOutTodayDate(forecast: ForecastWeatherResponse) -> [DailyForecastModel] {
        let model = Dictionary(grouping: forecast.data, by: {
            Calendar.current.startOfDay(for: Date(timeIntervalSince1970: TimeInterval($0.dateTimeUnix)))
        })
            .compactMapValues({ $0.sorted(by: { $0.main.temp > $1.main.temp }) })
            .compactMap { $0.value.first }
            .filter {
                let date = Date(timeIntervalSince1970: TimeInterval($0.dateTimeUnix))
                    .formatted(date: .numeric, time: .omitted)
                let today = Date.now.formatted(date: .numeric, time: .omitted)
                return date != today
            }
            .sorted(by: { $0.dateTimeUnix < $1.dateTimeUnix })

        let result = model.map {
            DailyForecastModel(
                date: Date(timeIntervalSince1970: TimeInterval($0.dateTimeUnix)),
                icon: $0.conditions.first!.icon,
                temperature: $0.main.temp
            )
        }

        return result
    }
}
