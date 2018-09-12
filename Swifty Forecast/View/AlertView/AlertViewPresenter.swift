//
//  AlertViewPresenter.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 4/20/18.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

final class AlertViewPresenter {
  static let shared = AlertViewPresenter()
  typealias SubmitCompletionHandler = (String) -> ()
  
  private init() {}
}


// MARK: - Present submit Alert
extension AlertViewPresenter {
  
  func presentSubmitAlert(in viewController: UIViewController, title: String, message: String, textFieldConfiguration: ((UITextField) -> ())? = nil, submitCompletionHandler: @escaping SubmitCompletionHandler) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addTextField(configurationHandler: textFieldConfiguration)
    
    let submitAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { action in
      guard let textField = alert.textFields?.first, let text = textField.text else { return }
      submitCompletionHandler(text)
    })
    
    let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: nil)
    
    alert.addAction(submitAction)
    alert.addAction(cancel)
    viewController.present(alert, animated: true, completion: nil)
  }
  
}


// MARK: - Present Error Alert
extension AlertViewPresenter {
  
  func presentError(withMessage msg: String, animated: Bool = true, completion: (() -> Void)? = nil) {
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindowLevelAlert + 1
    alertWindow.makeKeyAndVisible()
    
    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: msg, preferredStyle: .alert)
    let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default)
    alert.addAction(okAction)
    
    alertWindow.rootViewController?.present(alert, animated: animated, completion: completion)
  }
  
}


// MARK: - Present Popup Alert
extension AlertViewPresenter {
  
  func presentPopupAlert(in viewController: UIViewController, title: String?, message: String?, actionTitles: [String] = ["OK"], actions: [((UIAlertAction) -> ())?] = [nil]) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    for (index, title) in actionTitles.enumerated() {
      let action = UIAlertAction(title: title, style: .default, handler: actions[index])
      alert.addAction(action)
    }
    viewController.present(alert, animated: true, completion: nil)
  }
  
}

