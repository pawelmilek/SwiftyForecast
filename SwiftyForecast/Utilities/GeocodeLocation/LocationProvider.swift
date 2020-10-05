import UIKit
import CoreLocation

final class LocationProvider: NSObject {
  static let shared = LocationProvider()
  
  var authorizationCompletionBlock: ((_ isAuthorized: Bool) -> ())? = { _ in }
  
  var currentLocation: CLLocation? {
    didSet {
      guard let currentLocation = currentLocation else { return }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
        self?.locationFound?(currentLocation)
      }
    }
  }
  
  private let locationManager = CLLocationManager()
  private var didUpdateLocationsFlag = false
  private var locationFound: ((CLLocation) -> Void)?
  
  private override init() {
    super.init()
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    locationManager.allowsBackgroundLocationUpdates = false
    requestAuthorization()
  }
  
}

// MARK: - Request authorization
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
  
  func request(completion: @escaping (CLLocation) -> ()) {
    guard isLocationServicesEnabled else {
      ForecastNotificationCenter.post(.locationServicesDisabled)
      return
    }
    
    didUpdateLocationsFlag = false
    locationFound = completion
    locationManager.requestLocation()
  }
  
}

// MARK: - CLLocationManagerDelegate protocl
extension LocationProvider: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard !didUpdateLocationsFlag else { return }
    guard let mostRecentLocation = locations.first else { return }
    
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) Current location: \(mostRecentLocation.coordinate.latitude) \(mostRecentLocation.coordinate.longitude)")
    didUpdateLocationsFlag = true
    currentLocation = mostRecentLocation
    locationManager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      if let authorizationCompletionBlock = authorizationCompletionBlock {
        authorizationCompletionBlock(true)
      }
      
    case .denied, .restricted:
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
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error.localizedDescription)")
    ForecastNotificationCenter.post(.locationProviderDidFail)
  }
  
}
