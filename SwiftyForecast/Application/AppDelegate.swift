//
//  AppDelegate.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/09/18.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  private let googlePlacesAPIKey = "AIzaSyBRU9w0-Tlx3HWnQg13QnlXyngHHJoakkU"
  var window: UIWindow?
  
  internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    LocationProvider.shared.authorizationCompletionBlock = { isAuthorized in
      if !isAuthorized {
        LocationProvider.shared.presentLocationServicesSettingsPopupAlert()
      } else {
        LocationProvider.shared.requestLocation()
        let locationServiceDidBecomeEnable = NotificationCenterKey.locationServiceDidBecomeEnable.name
        NotificationCenter.default.post(name: locationServiceDidBecomeEnable, object: nil)
      }
    }
    
    GMSPlacesClient.provideAPIKey(googlePlacesAPIKey)
    setupStyle()
    return true
  }
}


// MARK: - Setup style
extension AppDelegate {
  
  func setupStyle() {
    setNavigationBarStyle()
  }
  
}


// MARK: - Set UINAvigationBar Attributes
private extension AppDelegate {
  
  func setNavigationBarStyle() {
    func setTransparentBackground() {
      UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
      UINavigationBar.appearance().shadowImage = UIImage()
      UINavigationBar.appearance().isTranslucent = true
      UINavigationBar.appearance().clipsToBounds = false
    }
    
    func setTitleTextColor() {
      let textAttributes = [NSAttributedString.Key.foregroundColor: Style.NavigationBar.titleTextColor]
      UINavigationBar.appearance().titleTextAttributes = textAttributes
    }
    
    func setBarButtonItemColor() {
      UINavigationBar.appearance().tintColor = Style.NavigationBar.barButtonItemColor
    }
    
    setTransparentBackground()
    setTitleTextColor()
    setBarButtonItemColor()
  }
  
}
