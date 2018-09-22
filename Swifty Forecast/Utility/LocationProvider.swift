//
//  LocationProvider.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 28/09/18.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

final class LocationProvider: NSObject {
  static let shared = LocationProvider()

  typealias CompletionHandler = (Coordinate) -> ()
  
  private let locationManager = CLLocationManager()
  private var currentLocation: CLLocationCoordinate2D? {
    didSet {
      guard let currentLocation = currentLocation else { return }
      let coordinate = Coordinate(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
      self.locationFound?(coordinate)
    }
  }
  
  private var didUpdateLocationsFlag = false
  private var locationFound: CompletionHandler?
  var authorizationCompletionBlock: ((_ isAuthorized: Bool)->())? = { _ in }
  
  
  
  private override init() {
    super.init()
    
    locationManager.delegate = self
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.allowsBackgroundLocationUpdates = false
    requestAuthorization()
  }
  
}


// MARK: - Private - Request authorization
extension LocationProvider {
  
  func requestAuthorization() {
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
  }
  
}


// MARK: - Private - Check if location service in enabled
extension LocationProvider {
  
  var isLocationServicesEnabled: Bool {
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    let isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
    let isAuthorizedWhenInUse = authorizationStatus == .authorizedWhenInUse
    let isAuthorizedAlways = authorizationStatus == .authorizedAlways
    
    return isLocationServicesEnabled && (isAuthorizedWhenInUse || isAuthorizedAlways)
  }

}


// MARK: - Get current location
extension LocationProvider {
  
  func getCurrentLocation(completionHandler: @escaping CompletionHandler) {
    guard isLocationServicesEnabled else {
      presentLocationServicesSettingsPopupAlert()
      return
    }
    
    didUpdateLocationsFlag = false
    locationFound = completionHandler
    locationManager.startUpdatingLocation()
  }
  
}


// MARK: - CLLocationManagerDelegate protocl
extension LocationProvider: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard !didUpdateLocationsFlag else { return }
    guard let location = locations.first?.coordinate else { return }
    
    didUpdateLocationsFlag = true
    DispatchQueue.main.async {
      self.currentLocation = location
      self.locationManager.stopUpdatingLocation()
    }
  }
  
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      if let authorizationCompletionBlock = authorizationCompletionBlock {
        authorizationCompletionBlock(true)
      }
      
    case .denied:
      if let authorizationCompletionBlock = authorizationCompletionBlock {
        authorizationCompletionBlock(false)
      }
      
    case .notDetermined:
      requestAuthorization()
      
    default:
      break
    }
  }
  
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    AlertViewPresenter.shared.presentError(withMessage: error.localizedDescription)
  }
  
}


// MARK: - Show settings alert view
extension LocationProvider {
  
  func presentLocationServicesSettingsPopupAlert() {
    let cancelAction: (UIAlertAction) -> () = { _ in }
    
    let settingsAction: (UIAlertAction) -> () = { _ in
      let settingsURL = URL(string: UIApplication.openSettingsURLString)!
      UIApplication.shared.open(settingsURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    let title = NSLocalizedString("Location Services Disabled", comment: "")
    let message = NSLocalizedString("Please enable Location Based Services. We will keep your location private", comment: "")
    let actionsTitle = [NSLocalizedString("Cancel", comment: ""), NSLocalizedString("Settings", comment: "")]
    
    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
    AlertViewPresenter.shared.presentPopupAlert(in: rootViewController!, title: title, message: message, actionTitles: actionsTitle, actions: [cancelAction, settingsAction])
  }
  
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
  return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
