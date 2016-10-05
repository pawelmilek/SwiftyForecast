//
//  HourForecastView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 03/10/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import Cartography
import WeatherIconsKit


class HourForecastView: UIView, CustomViewLayoutSetupable, CustomViewSetupable {
    fileprivate let iconLabel = UILabel()
    fileprivate let dateLabel = UILabel()
    fileprivate let temperaturesLabel = UILabel()
    fileprivate let descriptionLabel = UILabel()
    var isConstraints = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.setupStyle()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


// MARK: Update Constraints
extension HourForecastView {
    
    override func updateConstraints() {
        if self.isConstraints {
            super.updateConstraints()
            return
        }
        
        self.setupLayout()
        
        super.updateConstraints()
        self.isConstraints = true
    }
}


// MARK: CustomViewLayoutSetupable
extension HourForecastView {
    
    func setupLayout() {
        let mergin: CGFloat = 8
        
        func setViewConstrain() {
            constrain(self) { view in
                view.height == 60
                return
            }
        }
    }
    
}


// MARK: CustomViewSetupable
extension HourForecastView {
    
    func setup() {
        
    }
    
    func setupStyle() {
        func setBorders() {
            let width: CGFloat = 1
            let borderColor = UIColor.blue.cgColor
            
            self.layer.borderWidth = width
            self.layer.borderColor = borderColor
        }
        
        
        setBorders()
    }
    
    
    func renderView(weather: Weather) {
        self.dateLabel.text = "\(weather.date.mediumDayMonth) \(weather.date.weekday)"
        self.iconLabel.attributedText = IconType(rawValue: weather.icon)!.fontIcon
        self.descriptionLabel.text = weather.description
        
        if MeasuringSystem.isMetric {
            guard let temperature = weather.currentTemperatureCelsius else { return }
            let currentTemp = temperature.roundAndConvertingToString() + "℃"
            self.temperaturesLabel.text = "\(currentTemp)"
        } else {
            guard let temperature = weather.currentTemperatureFahrenheit else { return }
            let currentTmp = temperature.roundAndConvertingToString() + "℉"
            self.temperaturesLabel.text = "\(currentTmp)"
        }
    }
    
    func render() {
        
    }
    
}
