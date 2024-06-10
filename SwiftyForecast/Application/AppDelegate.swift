import UIKit
import TipKit
import FirebaseCore
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    @AppStorage("appearanceTheme") var appearanceTheme: AppearanceTheme = .systemDefault

    var window: UIWindow?
    private var coordinator: MainCoordinator?
    private var reviewObserver: ReviewObserver?
    private var networkMonitor: NetworkMonitor?
    private var cancellables = Set<AnyCancellable>()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupNetworkMonitor()
        setupFirebase()
        setupCoordinator()
        setupTips()
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

    func setupNetworkMonitor() {
        networkMonitor = NetworkMonitor()
        subscribeToNetworkMonitorPublisher()
        networkMonitor?.start()
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

    func subscribeToNetworkMonitorPublisher() {
        networkMonitor?.$hasNetworkConnection
            .print()
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasNetworkConnection in
                if hasNetworkConnection {
                    self?.coordinator?.popOfflineViewController()
                } else {
                    self?.coordinator?.pushOfflineViewController()
                }
            }
            .store(in: &cancellables)
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
