//
//  DayForecastView.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import WeatherIconsKit
import Cartography



final class DayForecastView: UIView, CustomViewLayoutSetupable, CustomViewSetupable  {
    fileprivate let iconLabel = UILabel()
    fileprivate let moonPhaseLabel = UILabel()
    fileprivate let dayLabel = UILabel()
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
extension DayForecastView {
    
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
extension DayForecastView {
    
    func setupLayout() {
        let mergin: CGFloat = 8
        
        func setViewConstrain() {
            constrain(self) { view in
                view.height == 60
                return
            }
        }
        
        func setIconLabelConstrain() {
            constrain(self.iconLabel) { view in
                view.centerY == view.superview!.centerY
                view.left == view.superview!.left + mergin
                view.width == view.height
                view.height == 60
            }
        }
        
        func setMoonPhaseLabelConstrain() {
            constrain(self.moonPhaseLabel, self.iconLabel) { view, view2 in
                view.centerY == view.superview!.centerY
                view.left == view2.right + mergin
                view.width == view.height
                view.height == 40
            }
        }
        
        func setDayLabelConstrain() {
            constrain(self.dayLabel, self.moonPhaseLabel) { view, view2 in
                view.centerY == view.superview!.centerY
                view.left == view2.right + mergin
            }
        }
        
        func setTemperaturesLabelConstrain() {
            constrain(self.temperaturesLabel) { view in
                view.centerY == view.superview!.centerY
                view.right == view.superview!.right - mergin
            }
        }
        
        func setDescriptionLabelConstrain() {
            constrain(self.descriptionLabel, self.moonPhaseLabel) { view, view2 in
                view.left == view2.right + mergin
                view.right == view.superview!.right - mergin
                view.bottom == view.superview!.bottom
            }
            
            constrain(self.descriptionLabel, self.dayLabel) { view, view2 in
                view.height == view2.height
            }
        }
        
        setViewConstrain()
        setIconLabelConstrain()
        setMoonPhaseLabelConstrain()
        setDayLabelConstrain()
        setTemperaturesLabelConstrain()
        setDescriptionLabelConstrain()
        
    }
}

// MARK: CustomViewSetupable
extension DayForecastView {
    
    func setup() {
        self.addSubview(self.iconLabel)
        self.addSubview(self.moonPhaseLabel)
        self.addSubview(self.dayLabel)
        self.addSubview(self.temperaturesLabel)
        self.addSubview(self.descriptionLabel)
    }
    
    
    func setupStyle() {
        func setBorders() {
            let width: CGFloat = 1
            let borderColor = UIColor.blue.cgColor
            
            self.layer.borderWidth = width
            self.layer.borderColor = borderColor
            
            self.iconLabel.layer.borderWidth = width
            self.iconLabel.layer.borderColor = borderColor
            self.moonPhaseLabel.layer.borderWidth = width
            self.moonPhaseLabel.layer.borderColor = borderColor
            self.dayLabel.layer.borderWidth = width
            self.dayLabel.layer.borderColor = borderColor
            self.temperaturesLabel.layer.borderWidth = width
            self.temperaturesLabel.layer.borderColor = borderColor
            self.descriptionLabel.layer.borderWidth = width
            self.descriptionLabel.layer.borderColor = borderColor
        }
        
        
        func setLabelsAttribute() {
            let textColor = UIColor.white
            
            self.iconLabel.textColor = textColor
            self.iconLabel.textAlignment = .center
            self.moonPhaseLabel.textColor = textColor
            self.moonPhaseLabel.textAlignment = .center
            self.dayLabel.font = UIFont.latoLightFont(ofSize: 16)
            self.dayLabel.textColor = textColor
            self.dayLabel.textAlignment = .left
            self.temperaturesLabel.font = UIFont.latoLightFont(ofSize: 16)
            self.temperaturesLabel.textColor = textColor
            self.temperaturesLabel.textAlignment = .right
            self.descriptionLabel.font = UIFont.latoLightFont(ofSize: 11)
            self.descriptionLabel.textColor = textColor
            self.descriptionLabel.textAlignment = .left
        }
        
        
        // MARK: TEST to keep track on the view size and position
        //setBorders()
        setLabelsAttribute()
    }
    
    func renderView(weather: Weather) {
        self.dayLabel.text = weather.date.dayMonth
        self.iconLabel.attributedText = IconType(rawValue: weather.icon)!.fontIcon
        self.moonPhaseLabel.attributedText = weather.moonPhase?.icon
        self.descriptionLabel.text = weather.description
        
        if MeasuringSystem.isMetric {
            guard let maxTmp = weather.maxTemperatureCelsius else { return }
            guard let minTmp = weather.minTemperatureCelsius else { return }
            let max = maxTmp.roundAndConvertingToString() + "℃"
            let min = minTmp.roundAndConvertingToString() + "℃"
            self.temperaturesLabel.text = "\(max)/\(min)"
        } else {
            guard let maxTmp = weather.maxTemperatureFahrenheit else { return }
            guard let minTmp = weather.minTemperatureFahrenheit else { return }
            let max = maxTmp.roundAndConvertingToString() + "℉"
            let min = minTmp.roundAndConvertingToString() + "℉"
            self.temperaturesLabel.text = "\(max)/\(min)"
        }
        
    }
}

