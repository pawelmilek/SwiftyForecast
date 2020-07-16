import UIKit
import CoreLocation

final class LocationProvider: NSObject {
  static let shared = LocationProvider()
  
  typealias CompletionHandler = (CLLocation) -> ()
  
  private let locationManager = CLLocationManager()
  private var didUpdateLocationsFlag = false
  private var locationFound: CompletionHandler?
  var authorizationCompletionBlock: ((_ isAuthorized: Bool) -> ())? = { _ in }
  var currentLocation: CLLocation? {
    didSet {
      guard let currentLocation = currentLocation else { return }
      self.locationFound?(currentLocation)
    }
  }
  
  private override init() {
    super.init()
    
    locationManager.delegate = self
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
  
  func requestLocation() {
    locationManager.requestLocation()
  }
  
  func requestLocation(completionHandler: @escaping CompletionHandler) {
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
    guard let location = locations.first else { return }
    
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
    AlertViewPresenter.presentError(withMessage: error.localizedDescription)
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
    let message = NSLocalizedString("Please enable Location Services. We will keep your data private.", comment: "")
    let actionsTitle = [NSLocalizedString("Cancel", comment: ""), NSLocalizedString("Settings", comment: "")]
    
    let rootViewController = UIApplication.topViewController
    AlertViewPresenter.presentPopupAlert(in: rootViewController!, title: title, message: message, actionTitles: actionsTitle, actions: [cancelAction, settingsAction])
  }
  
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
  return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
