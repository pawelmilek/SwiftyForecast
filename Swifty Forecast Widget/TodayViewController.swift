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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
}

// MARK: - NCWidgetProviding protocol
extension TodayViewController: ViewSetupable {
  
  func setup() {
    let icon = ConditionFontIcon.make(icon: "partly-cloudy-day", font: 55)
    iconLabel.textColor = UIColor.white
    iconLabel.attributedText = icon?.attributedIcon
    
    cityNameLabel.text = "Chicago"
    cityNameLabel.font = UIFont(name:  "HelveticaNeue-Light", size: 20)
    cityNameLabel.textColor = UIColor.blackShade
    cityNameLabel.textAlignment = .left
    cityNameLabel.numberOfLines = 1
    
    conditionSummaryLabel.text = "Partly cloudy day"
    conditionSummaryLabel.font = UIFont(name:  "HelveticaNeue-Medium", size: 13)
    conditionSummaryLabel.textColor = UIColor.blackShade
    conditionSummaryLabel.textAlignment = .left
    conditionSummaryLabel.numberOfLines = 2
    
    humidityLabel.text = "Humidity: 67%"
    humidityLabel.font = UIFont(name:  "HelveticaNeue-Medium", size: 13)
    humidityLabel.textColor = UIColor.blackShade
    humidityLabel.textAlignment = .left
    humidityLabel.numberOfLines = 1
    
    temperatureLabel.text = "85" + "\u{00B0}"
    temperatureLabel.font = UIFont(name:  "HelveticaNeue-Light", size: 60)
    temperatureLabel.textColor = UIColor.blackShade
    temperatureLabel.textAlignment = .left
    temperatureLabel.numberOfLines = 1
    
    temperatureMaxMinLabel.text = "60\u{00B0} / 45\u{00B0}"
    temperatureMaxMinLabel.font = UIFont(name:  "HelveticaNeue-Light", size: 16)
    temperatureMaxMinLabel.textColor = UIColor.blackShade
    temperatureMaxMinLabel.textAlignment = .left
    temperatureMaxMinLabel.numberOfLines = 1
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
