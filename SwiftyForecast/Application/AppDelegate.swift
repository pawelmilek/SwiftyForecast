import UIKit
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var coordinator: MainCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupCoordinator()
//        setupNetworkReachabilityHandling()
        setNavigationBarStyle()
        debugPrintRealmFileURL()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: .applicationDidBecomeActive, object: self)
    }
}

// MARK: - Private - Setups
private extension AppDelegate {

    func setupCoordinator() {
        coordinator = MainCoordinator(navigationController: UINavigationController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator?.navigationController
        window?.makeKeyAndVisible()
        coordinator?.start()
    }

    func setupNetworkReachabilityHandling() {
        let onNetworkUnavailable = {
            if let rootViewController = self.window?.rootViewController as? UINavigationController {
                let offlineViewController = OfflineViewController()
                rootViewController.pushViewController(offlineViewController, animated: false)
            }
        }

        let onNetworkAvailable = {
            if let rootViewController = self.window?.rootViewController as? UINavigationController {
                if (rootViewController.viewControllers.first(where: {
                    $0.view.tag == OfflineViewController.identifier
                })) != nil {
                    DispatchQueue.main.async {
                        rootViewController.popViewController(animated: false)
                    }
                }
            }
        }

        NetworkReachabilityManager.shared.whenUnreachable { _ in
            debugPrint("File: \(#file), Function: \(#function), line: \(#line) Network whenUnreachable")
            onNetworkUnavailable()
        }

        NetworkReachabilityManager.shared.whenReachable { _ in
            debugPrint("File: \(#file), Function: \(#function), line: \(#line) Network whenReachable")
            onNetworkAvailable()
        }
    }

    func setNavigationBarStyle() {
        let setTransparentBackground = {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().isTranslucent = true
            UINavigationBar.appearance().clipsToBounds = false
        }

        let setTitleTextColor = {
            let textAttributes = [NSAttributedString.Key.foregroundColor: Style.NavigationBar.titleColor]
            UINavigationBar.appearance().titleTextAttributes = textAttributes
        }

        let setBarButtonItemColor = {
            UINavigationBar.appearance().tintColor = Style.NavigationBar.barButtonItemColor
        }

        setTransparentBackground()
        setTitleTextColor()
        setBarButtonItemColor()
    }

    func debugPrintRealmFileURL() {
        let realmURLAbsoluteString = RealmProvider.shared.fileURL?.absoluteString ?? InvalidReference.undefined
        debugPrint("Realm file URL: \(realmURLAbsoluteString)")
    }
}
