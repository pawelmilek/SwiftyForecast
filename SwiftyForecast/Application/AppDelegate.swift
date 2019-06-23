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
        ForecastNotificationCenter.post(.locationServiceDidBecomeEnable)
      }
    }
    
    GMSPlacesClient.provideAPIKey(googlePlacesAPIKey)
    setUpStyle()
    return true
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    ForecastNotificationCenter.post(.applicationDidBecomeActive)
  }
}

// MARK: - Setup style
extension AppDelegate {
  
  func setUpStyle() {
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
