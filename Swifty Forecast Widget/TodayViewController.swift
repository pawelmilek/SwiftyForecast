//
//  TodayViewController.swift
//  WeatherForecastWidget
//
//  Created by Pawel Milek on 30/09/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
  @IBOutlet private weak var iconLabel: UILabel!
  @IBOutlet private weak var cityNameLabel: UILabel!
  @IBOutlet private weak var conditionSummaryLabel: UILabel!
  @IBOutlet private weak var humidityLabel: UILabel!
  @IBOutlet private weak var temperatureLabel: UILabel!
  @IBOutlet private weak var temperatureMaxMinLabel: UILabel!
  
  typealias WidgetStyle = Style.WeatherWidget
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupStyle()
  }
  
}

// MARK: - NCWidgetProviding protocol
extension TodayViewController: ViewSetupable {
  
  func setup() {
    let icon = ConditionFontIcon.make(icon: "partly-cloudy-day", font: WidgetStyle.iconLabelFontSize)
    iconLabel.attributedText = icon?.attributedIcon
    
    cityNameLabel.text = "Chicago"
    conditionSummaryLabel.text = "Partly cloudy day"
    humidityLabel.text = "Humidity: 67%"
    temperatureLabel.text = "85" + "\u{00B0}"
    temperatureMaxMinLabel.text = "60\u{00B0} / 45\u{00B0}"
  }
  
  func setupStyle() {
    iconLabel.textColor = WidgetStyle.iconLabelTextColor
    
    cityNameLabel.font = WidgetStyle.cityNameLabelFont
    cityNameLabel.textColor = WidgetStyle.cityNameLabelTextColor
    cityNameLabel.textAlignment = WidgetStyle.cityNameLabelTextAlignment
    cityNameLabel.numberOfLines = WidgetStyle.cityNameLabelNumberOfLines
    
    conditionSummaryLabel.font = WidgetStyle.conditionSummaryLabelFont
    conditionSummaryLabel.textColor = WidgetStyle.conditionSummaryLabelTextColor
    conditionSummaryLabel.textAlignment = WidgetStyle.conditionSummaryLabelTextAlignment
    conditionSummaryLabel.numberOfLines = WidgetStyle.conditionSummaryLabelNumberOfLines
    
    humidityLabel.font = WidgetStyle.humidityLabelFont
    humidityLabel.textColor = WidgetStyle.humidityLabelTextColor
    humidityLabel.textAlignment = WidgetStyle.humidityLabelTextAlignment
    humidityLabel.numberOfLines = WidgetStyle.humidityLabelNumberOfLines
    
    temperatureLabel.font = WidgetStyle.temperatureLabelFont
    temperatureLabel.textColor = WidgetStyle.temperatureLabelTextColor
    temperatureLabel.textAlignment = WidgetStyle.temperatureLabelTextAlignment
    temperatureLabel.numberOfLines = WidgetStyle.temperatureLabelNumberOfLines
    
    temperatureMaxMinLabel.font = WidgetStyle.temperatureMaxMinLabelFont
    temperatureMaxMinLabel.textColor = WidgetStyle.temperatureMaxMinLabelTextColor
    temperatureMaxMinLabel.textAlignment = WidgetStyle.temperatureMaxMinLabelTextAlignment
    temperatureMaxMinLabel.numberOfLines = WidgetStyle.temperatureMaxMinLabelNumberOfLines
  }
  
}


// MARK: - NCWidgetProviding protocol
extension TodayViewController: NCWidgetProviding {
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    completionHandler(NCUpdateResult.newData)
  }
  
  func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets.zero
  }
  
}
