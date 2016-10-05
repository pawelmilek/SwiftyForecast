//
//  CurrentWeatherView.swift
//  Pretty Weather
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import Foundation
import LatoFont
import WeatherIconsKit
import Cartography


class CurrentWeatherView: UIView, CustomViewLayoutSetupable, CustomViewSetupable {
    fileprivate var dateLabel = UILabel()
    fileprivate var cityLabel = UILabel()
    fileprivate var iconLabel = UILabel()
    fileprivate var descriptionLabel = UILabel()
    fileprivate var currentTemperatureLabel = UILabel()
    fileprivate var thermometerLabel = UILabel()
    
    var isConstraints = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.setupLayout()
        self.setupStyle()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



// MARK: Update Constraints
extension CurrentWeatherView {
    
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


// MAKR: CustomViewLayoutSetupable
extension CurrentWeatherView {
    
    func setupLayout() {
        let margin: CGFloat = 8
        
        func setViewConstrain() {
            constrain(self) { view in
                view.height == 440
            }
        }
        
        func setDateLabelConstrain() {
            constrain(self.dateLabel) { view in
                view.top == view.superview!.top
                view.left == view.superview!.left + margin
                view.right == view.superview!.right - margin
                view.height == 90
            }
        }
        
        func setIconLabelConstrain() {
            constrain(self.iconLabel, self.dateLabel) { view, view2 in
                view.top == view2.bottom
                view.left == view.superview!.left + margin
                view.width == 70
                view.width == view.height
            }
        }
        
        func setDescriptionLabelConstrain() {
            constrain(self.descriptionLabel, self.iconLabel) { view, view2 in
                view.top == view2.top
                view.left == view2.right + margin
                view.height == view2.height
                view.right == view.superview!.right - margin
            }
        }
        
        func setCurrentTemperatureLabelConstrain() {
            constrain(self.currentTemperatureLabel, self.iconLabel) { view, view2 in
                view.top == view2.bottom
                view.left == view2.left
                view.right == view.superview!.right - margin
            }
            
            constrain(self.currentTemperatureLabel, self.cityLabel) { view, view2 in
                view.bottom == view2.top
            }
        }
        
        func setThermometerLabelConstrain() {
            constrain(self.thermometerLabel, self.currentTemperatureLabel) { view, view2 in
                view.top == view2.top
                view.left == view.superview!.left + margin
                view.height == 60
                view.width == 30
            }
            
        }
        
        func setCityLabelConstrain() {
            constrain(self.cityLabel) { view in
                view.bottom == view.superview!.bottom
                view.left == view.superview!.left + margin
                view.right == view.superview!.right - margin
                view.height == 50
            }
        }
        
        
        setViewConstrain()
        setDateLabelConstrain()
        setCityLabelConstrain()
        setIconLabelConstrain()
        setDescriptionLabelConstrain()
        setCurrentTemperatureLabelConstrain()
        setThermometerLabelConstrain()
    }
    
}


// MARK: CustomViewSetupable
extension CurrentWeatherView {
    
    func setup() {
        self.addSubview(self.dateLabel)
        self.addSubview(self.cityLabel)
        self.addSubview(self.currentTemperatureLabel)
        self.addSubview(self.thermometerLabel)
        self.addSubview(self.iconLabel)
        self.addSubview(self.descriptionLabel)
    }
    
    
    func setupStyle() {
        func setLabelsBorder() {
            let width: CGFloat = 1
            let color = UIColor.red.cgColor
            
            self.layer.borderWidth = width
            self.layer.borderColor = color
            
            self.dateLabel.layer.borderWidth = width
            self.dateLabel.layer.borderColor = color
            
            self.cityLabel.layer.borderWidth = width
            self.cityLabel.layer.borderColor = color
            
            self.iconLabel.layer.borderWidth = width
            self.iconLabel.layer.borderColor = color
            
            self.descriptionLabel.layer.borderWidth = width
            self.descriptionLabel.layer.borderColor = color
            
            self.currentTemperatureLabel.layer.borderWidth = width
            self.currentTemperatureLabel.layer.borderColor = color
            
            self.thermometerLabel.layer.borderWidth = width
            self.thermometerLabel.layer.borderColor = color
        }
        
        
        func labelsStyle() {
            let textColor = UIColor.white
            self.dateLabel.font = UIFont.latoFont(ofSize: 48)
            self.dateLabel.textColor = textColor
            self.dateLabel.textAlignment = .center
            
            self.cityLabel.font = UIFont.latoFont(ofSize: 20)
            self.cityLabel.textColor = textColor
            self.cityLabel.textAlignment = .left
            
            self.iconLabel.textColor = textColor
            self.iconLabel.textAlignment = .center
            self.descriptionLabel.font = UIFont.latoFont(ofSize: 20)
            self.descriptionLabel.textColor = textColor
            self.descriptionLabel.textAlignment = .center
            
            self.currentTemperatureLabel.font = UIFont.latoFont(ofSize: 120)
            self.currentTemperatureLabel.textColor = textColor
            self.currentTemperatureLabel.textAlignment = .center

            self.thermometerLabel.textColor = textColor
            self.thermometerLabel.textAlignment = .center
        }
        
        // MARK: TEST to keep track on the view size and position
        //setLabelsBorder()
        labelsStyle()
    }
    
    func renderView(weather: Weather) {
        self.dateLabel.text = weather.date.longDayMonth
        self.cityLabel.text = weather.cityAndCountry
        self.descriptionLabel.text = weather.description
        self.iconLabel.attributedText = IconType(rawValue: weather.icon)!.fontIcon
        self.thermometerLabel.attributedText = weather.thermometerIcon
        
        
        if MeasuringSystem.isMetric {
            guard let currentTmp = weather.currentTemperatureCelsius else { return }
            self.currentTemperatureLabel.text = currentTmp.roundAndConvertingToString() + "℃"
        } else {
            guard let currentTmp = weather.currentTemperatureFahrenheit else { return }
            self.currentTemperatureLabel.text = currentTmp.roundAndConvertingToString() + "℉"
        }
    }

}
