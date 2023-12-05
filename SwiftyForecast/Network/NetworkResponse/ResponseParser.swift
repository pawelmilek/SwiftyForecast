import Foundation

struct ResponseParser {
    private init() { }

    static func parse(current: CurrentWeatherResponse) -> CurrentWeatherModel {
        let currentDate = Date(timeIntervalSince1970: TimeInterval(current.dateTimeUnix))
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(current.metadata.sunrise))
        let sunsetDate = Date(timeIntervalSince1970: TimeInterval(current.metadata.sunset))
        let currentDescription = current.conditions.first?.description ?? InvalidReference.undefined
        let currentIcon = current.conditions.first?.icon ?? InvalidReference.undefined
        let dayNightSign = String(currentIcon.suffix(1))
        let dayNightState = DayNightState(rawValue: dayNightSign) ?? .day

        let currentWeatherModel = CurrentWeatherModel(
            date: currentDate,
            dayNightState: dayNightState,
            temperature: current.main.temp,
            maxTemperature: current.main.tempMax,
            minTemperature: current.main.tempMin,
            description: currentDescription,
            icon: currentIcon,
            humidity: current.main.humidity,
            pressure: current.main.pressure,
            windSpeed: current.wind.speed,
            sunrise: sunriseDate,
            sunset: sunsetDate
        )

        return currentWeatherModel
    }

    static func parse(forecast: ForecastWeatherResponse) -> ForecastWeatherModel {
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

    private static func groupAndFilterOutTodayDate(forecast: ForecastWeatherResponse) -> [DailyForecastModel] {
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
