import UIKit
import TipKit
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    @AppStorage("userThemeSetting") var userThemeSetting: AppearanceTheme?

    var window: UIWindow?
    private var coordinator: MainCoordinator?
    private let networkReachabilityManager = NetworkReachabilityManager.shared

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupCoordinator()
        setupTips()
        setupNetworkReachabilityHandling()
        setNavigationBarStyle()
        setupUserInterfaceStyle()
        setupNotificationCenter()
        debugPrintRealmFileURL()
        return true
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

    func setupTips() {
//        try? Tips.resetDatastore()
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
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
                    rootViewController.popViewController(animated: false)
                }
            }
        }

        networkReachabilityManager.whenUnreachable { _ in
            DispatchQueue.main.async {
                onNetworkUnavailable()
            }
        }

        networkReachabilityManager.whenReachable { _ in
            DispatchQueue.main.async {
                onNetworkAvailable()
            }
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

    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setupUserInterfaceStyle),
            name: .didChangeAppearance,
            object: nil
        )
    }

    @objc
    func setupUserInterfaceStyle() {
        switch userThemeSetting {
        case .dark:
            window?.overrideUserInterfaceStyle = .dark

        case .light:
            window?.overrideUserInterfaceStyle = .light

        default:
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }

    func debugPrintRealmFileURL() {
        RealmManager.shared.debugPrintRealmFileURL()
    }
}
