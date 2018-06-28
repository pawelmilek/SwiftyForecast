//
//  WeatherDatastore.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import SwiftyJSON


class WeatherDatastore {
    private var darkURL = ""
    fileprivate weak var city: City? = nil
    
    
    
    // MARK: Retrieve Current Weather
    func retrieveCurrentWeather(at coordinate: Coordinate,
                                block: @escaping (_ condition: Weather) -> Void) {
        
        //https://api.darksky.net/forecast/6a92402c27dfc4740168ec5c0673a760/42.3601,-71.0589?exclude=minutely,hourly,alerts,flags?units=us
        
        self.createCompleteURL(with: coordinate)
        Alamofire.request(self.darkURL).responseJSON { response in
                if(response.result.value == nil) {
                    print("response.result.value == nil")
                    
                } else {
                    let json = JSON(response.result.value!)
                    let lat = json[JSONResponseFormat.latitude].doubleValue
                    let long = json[JSONResponseFormat.longitude].doubleValue
                    
                    
                    Geocoder.getCityFrom(latitude: lat, longitude: long, completionBlock: {(cityLocation) in
                        self.city = cityLocation
                        //print("completionBlock:", cityLocation.name, cityLocation.country)
                        block(self.createWeather(from: json))
                    })
                }
        }
        
    }
    
    // MARK: Retrieve Hourly Weather
    func retrieveHourlyWeather(at coordinate: Coordinate, forecast: Int,
                               block: @escaping (_ conditions: [Weather]) -> Void) {
        
        self.createCompleteURL(with: coordinate)
        Alamofire.request(self.darkURL).responseJSON { response in
            //print(response)
            
            if(response.result.value == nil) {
                print("response.result.value == nil")
                
            } else {
                let json = JSON(response.result.value!)
                var hoursForecast = [Weather]()
                let hourlyData: [JSON] = json[JSONResponseFormat.hourly][JSONResponseFormat.data].arrayValue
                
                let hourlyConditions: [Weather] = hourlyData.map() {
                    return self.createHourForecast(from: $0)
                }
                
                if !hourlyConditions.isEmpty {
                    hoursForecast = Array(hourlyConditions[0..<forecast])
                }
                
                block(hoursForecast)
            }
        }
        
    }
    
    // MARK: Retrieve Daily Weather
    func retrieveDailyForecast(at coordinate: Coordinate, forecast: Int,
                               block: @escaping (_ conditions: [Weather]) -> Void) {
        
        self.createCompleteURL(with: coordinate)
        Alamofire.request(self.darkURL).responseJSON { response in
            //print(response)
            
            if(response.result.value == nil) {
                print("response.result.value == nil")
                
            } else {
                let json = JSON(response.result.value!)
                var daysWithoutToday = [Weather]()
            
                let dailyData: [JSON] = json[JSONResponseFormat.daily][JSONResponseFormat.data].arrayValue
                let dailyConditions: [Weather] = dailyData.map() {
                    return self.createDayForecast(from: $0)
                }
                
                if !dailyConditions.isEmpty {
                    daysWithoutToday = Array(dailyConditions[1..<forecast + 1])
                }
                
                block(daysWithoutToday)
            }
        }
    }
    
    
    private func createCompleteURL(with coordinate: Coordinate) {
        let exclude = DarkSkyAPI.exclude
        let units = DarkSkyAPI.units
        self.darkURL = DarkSkyAPI.requestURL + "\(coordinate.latitude),\(coordinate.longitude)" + exclude + units
    }

}


// MARK: Create weather forecast from JSON
fileprivate extension WeatherDatastore {
    
    func createWeather(from json: JSON) -> Weather {
        let timestamp = json[JSONResponseFormat.currently][JSONResponseFormat.DataPoint.time].numberValue
        let icon = json[JSONResponseFormat.currently][JSONResponseFormat.DataPoint.icon].stringValue
        let summary = json[JSONResponseFormat.currently][JSONResponseFormat.DataPoint.summary].stringValue
        let currentTempFahr = json[JSONResponseFormat.currently][JSONResponseFormat.DataPoint.temperature].doubleValue
        
      let weather = Weather(city: city, timeStamp: Int(truncating: timestamp), icon: icon, description: summary, currentTemp: currentTempFahr)

        return weather
    }
    
    func createHourForecast(from json: JSON) -> Weather {
        let timestamp = json[JSONResponseFormat.DataPoint.time].numberValue
        let icon = json[JSONResponseFormat.DataPoint.icon].stringValue
        let summary = json[JSONResponseFormat.DataPoint.summary].stringValue
        let currentTemp = json[JSONResponseFormat.DataPoint.temperature].doubleValue
        
      let weather = Weather(city: nil, timeStamp: Int(truncating: timestamp), icon: icon, description: summary, currentTemp: currentTemp)
        
        return weather
    }
    
    func createDayForecast(from json: JSON) -> Weather {
        let timestamp = json[JSONResponseFormat.DataPoint.time].numberValue
        let icon = json[JSONResponseFormat.DataPoint.icon].stringValue
        let summary = json[JSONResponseFormat.DataPoint.summary].stringValue
        let minTempFahr = json[JSONResponseFormat.DataPoint.temperatureMin].doubleValue
        let maxTempFahr = json[JSONResponseFormat.DataPoint.temperatureMax].doubleValue
        let moonPhase = json[JSONResponseFormat.DataPoint.moonPhase].doubleValue
        
      let weather = Weather(city: nil, timeStamp: Int(truncating: timestamp), icon: icon, description: summary, currentTemp: nil, minTemp: minTempFahr, maxTemp: maxTempFahr, moonPhaseLunation: moonPhase)
        
        return weather
    }
}
