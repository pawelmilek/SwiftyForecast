import Foundation

struct ResponseParser {
    func parse(current: CurrentWeatherResponse) -> CurrentWeatherModel {
        let currentDate = Date(timeIntervalSince1970: TimeInterval(current.dateTimeUnix))
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(current.metadata.sunrise))
        let sunsetDate = Date(timeIntervalSince1970: TimeInterval(current.metadata.sunset))

        let condition: ConditionModel
        if let currentCondition = current.conditions.first {
            let id = currentCondition.id
            let iconCode = currentCondition.icon
            let name = currentCondition.main
            let description = currentCondition.description
            condition = ConditionModel(id: id, iconCode: iconCode, name: name, description: description)
        } else {
            condition = ConditionModel(
                id: -1,
                iconCode: InvalidReference.undefined,
                name: InvalidReference.undefined,
                description: InvalidReference.undefined
            )
        }

        let temperatureValue = TemperatureValue(
            current: current.main.temp,
            min: current.main.tempMin,
            max: current.main.tempMax
        )

        let currentWeatherModel = CurrentWeatherModel(
            date: currentDate,
            temperature: temperatureValue,
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
                description: $0.conditions.first?.description ?? InvalidReference.undefined,
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
