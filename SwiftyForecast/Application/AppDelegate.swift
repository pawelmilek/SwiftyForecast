import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  internal func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setupLocationProvider()
    setupNetworkReachabilityHandling()
    setUpStyle()
    
    // MARK: - Get Realm path
    debugPrint("File: \(#file), \(RealmProvider.core.configuration.fileURL!)")
    try! City.deleteAll()
    
    return true
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    ForecastNotificationCenter.post(.applicationDidBecomeActive)
  }
}

// MARK: - Private - Setup style
private extension AppDelegate {
  
  func setupLocationProvider() {
    LocationProvider.shared.authorizationCompletionBlock = { isAuthorized in
      if isAuthorized {
        LocationProvider.shared.requestLocation()
        ForecastNotificationCenter.post(.locationServiceDidRequestLocation)

      } else {
        LocationProvider.shared.presentLocationServicesSettingsPopupAlert()
      }
    }
  }
  
  func setupNetworkReachabilityHandling() {
    let onNetworkNotAvailable = {
      if let rootViewController = self.window?.rootViewController as? UINavigationController {        
        let offlineViewController = OfflineViewController()
        rootViewController.pushViewController(offlineViewController, animated: false)
      }
    }
    
    let onNetworkAvailable = {
      if let rootViewController = self.window?.rootViewController as? UINavigationController {
        if let _ = rootViewController.viewControllers.first(where: { $0.view.tag == OfflineViewController.identifier }) {
          DispatchQueue.main.async {
            rootViewController.popViewController(animated: false)
          }
        }
      }
    }
    
    NetworkReachabilityManager.shared.isUnreachable {
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) Network isUnreachable")
      onNetworkNotAvailable() // Will run only once when app is launching
    }
    
    NetworkReachabilityManager.shared.whenUnreachable { _ in
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) Network whenUnreachable")
      onNetworkNotAvailable() // Network listener to pick up network changes in real-time
    }
    
    NetworkReachabilityManager.shared.whenReachable { _ in
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) Network whenReachable")
      onNetworkAvailable()
    }
  }
  
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
