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
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
