//
//  AlertViewPresenterDelegate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 4/20/18.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

protocol AlertViewPresenterDelegate: class {
  func alertView(_ alertViewPresenter: AlertViewPresenter, didSubmit result: String)
}
