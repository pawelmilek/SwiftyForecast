import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  internal func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    LocationProvider.shared.authorizationCompletionBlock = { isAuthorized in
      if !isAuthorized {
        LocationProvider.shared.presentLocationServicesSettingsPopupAlert()
      } else {
        LocationProvider.shared.requestLocation()
        ForecastNotificationCenter.post(.locationServiceDidBecomeEnable)
      }
    }
    
    setUpStyle()
    
    // MARK: - Get Realm path
    debugPrint(RealmProvider.cities.configuration.fileURL!)
    try! CityRealm.deleteAll()
    
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
    let setTransparentBackground = {
      UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
      UINavigationBar.appearance().shadowImage = UIImage()
      UINavigationBar.appearance().isTranslucent = true
      UINavigationBar.appearance().clipsToBounds = false
    }
    
    let setTitleTextColor = {
      let textAttributes = [NSAttributedString.Key.foregroundColor: Style.NavigationBar.titleTextColor]
      UINavigationBar.appearance().titleTextAttributes = textAttributes
    }

    let setBarButtonItemColor = {
      UINavigationBar.appearance().tintColor = Style.NavigationBar.barButtonItemColor
    }

    setTransparentBackground()
    setTitleTextColor()
    setBarButtonItemColor()
  }

}
