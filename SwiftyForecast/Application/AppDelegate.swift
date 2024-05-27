import UIKit
import TipKit
import Combine
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    @AppStorage("appearanceTheme") var appearanceTheme: AppearanceTheme = .systemDefault

    var window: UIWindow?
    private var coordinator: MainCoordinator?
    private var reviewObserver: ReviewObserver?
    private let networkReachabilityManager = NetworkReachabilityManager.shared

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupFirebase()
        setupCoordinator()
        setupTips()
        setupNetworkReachabilityHandling()
        setNavigationBarStyle()
        setupAppearanceTheme()
        setupAppearanceThemeNotificationCenter()
        setupReviewObserver()
        debugPrintRealmFileURL()
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        setupAppearanceTheme()
    }
}

// MARK: - Private - Setups
private extension AppDelegate {

    func setupFirebase() {
        FirebaseApp.configure()
    }

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

    func setupReviewObserver() {
        if let topViewController = coordinator?.topViewController as? ReviewObserverEventResponder {
            reviewObserver = ReviewObserver(
                eventResponder: topViewController,
                notificationCenter: .default
            )
            reviewObserver?.start()
        } else {
            reviewObserver?.stop()
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

    func setupAppearanceThemeNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setupAppearanceTheme),
            name: .didChangeAppearance,
            object: nil
        )
    }

    @objc
    func setupAppearanceTheme() {
        switch appearanceTheme {
        case .dark:
            window?.overrideUserInterfaceStyle = .dark

        case .light:
            window?.overrideUserInterfaceStyle = .light

        case .systemDefault:
            window?.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
        }
    }

    func debugPrintRealmFileURL() {
        RealmManager.shared.debugPrintRealmFileURL()
    }
}
