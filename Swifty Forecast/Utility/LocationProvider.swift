//
//  LocationProvider.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationProvider: NSObject {
  static let shared = LocationProvider()
  
  private let locationManager = CLLocationManager()
  private var currentLocation: CLLocationCoordinate2D? {
    didSet {
      guard let currentLocation = currentLocation else { return }
      let coordinate = Coordinate(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
      self.locationFound?(coordinate)
    }
  }
  
  private var didUpdateLocationsFlag = false
  
  typealias CompletionHandler = (Coordinate) -> ()
  private var locationFound: CompletionHandler?
  
  
  private override init() {
    super.init()
    
    locationManager.delegate = self
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.allowsBackgroundLocationUpdates = false
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
  }
  
}

// MARK: - get current location
extension LocationProvider {
  
  func getCurrentLocation(completionHandler: @escaping CompletionHandler) {
    var isLocationServicesEnabled: Bool {
      let isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
      let isAuthorizedWhenInUse = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
      return isLocationServicesEnabled && isAuthorizedWhenInUse
    }
    
    guard isLocationServicesEnabled else {
      AlertViewPresenter.shared.presentError(withMessage: "Please enable location for Swifty Forecast")
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
  
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    AlertViewPresenter.shared.presentError(withMessage: error.localizedDescription)
  }
  
}

