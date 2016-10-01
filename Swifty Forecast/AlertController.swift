//
//  AlertController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit


final class AlertController: UIAlertController {
    fileprivate var alertWindow: UIWindow? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.alertWindow?.isHidden = true
        self.alertWindow = nil
    }
    
    
    func show() {
        self.show(animated: true)
    }

}



// MARK: Present Error 
extension AlertController {
    
    class func presentErrorAlert(error: Error) {
        let message = error.localizedDescription
        AlertController.presentAlertWith(title: "Error", andMessage: message)
    }
    
    
    class func presentErrorAlert(errorMessage: String) {
        AlertController.presentAlertWith(title: "Error", andMessage: errorMessage)
    }
}



// MARK: Present Alert with title and message
extension AlertController {
    
    class func presentAlertWith(title: String, andMessage msg: String) {
        let alert = AlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        alert.show()
    }
}


// MAKR: Show animated
private extension AlertController {
    
    func show(animated: Bool) {
        let blankVC = UIViewController()
        blankVC.view.backgroundColor = .clear
        
        let screenBounds = UIScreen.main.bounds
        let window = UIWindow(frame: screenBounds)
        
        window.rootViewController = blankVC
        window.backgroundColor = .clear
        window.windowLevel = UIWindowLevelAlert + 1
        window.makeKeyAndVisible()
        self.alertWindow = window
        
        
        blankVC.present(self, animated: true)
    }
}
