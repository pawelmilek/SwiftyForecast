import UIKit
import CoreLocation
import SafariServices

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(
            identifier: MainViewController.storyboardIdentifier
        ) { coder in
            MainViewController(
                viewModel: MainViewControllerViewModel(
                    geocodeLocation: GeocodedLocation(geocoder: CLGeocoder()),
                    notationSettings: NotationSettingsStorage(),
                    metricSystemNotification: NotificationCenterAdapter(),
                    currentLocationRecord: CurrentLocationRecord(
                        databaseManager: RealmManager()
                    ),
                    databaseManager: RealmManager(),
                    locationManager: LocationManager(),
                    analyticsManager: AnalyticsManager(
                        service: FirebaseAnalyticsService()
                    ),
                    networkMonitor: NetworkMonitor(),
                    service: WeatherService(
                        repository: WeatherRepository(
                            client: OpenWeatherClient(
                                decoder: JSONSnakeCaseDecoded()
                            )
                        ),
                        parse: WeatherResponseParser()
                    )
                ),
                coordinator: self,
                coder: coder
            )
        }

        navigationController.pushViewController(viewController, animated: false)
        debugPrint(RealmManager().description)
    }

    func openAbout() {
        navigationController.present(
            AboutViewController(
                viewModel: AboutViewModel(),
                coordinator: self
            ),
            animated: true
        )
    }

    func openAppearanceSwitch() {
        let appearanceViewController = AppearanceViewController(
            coordinator: self,
            notificationCenter: .default
        )
        navigationController.present(appearanceViewController, animated: true)
    }

    func openLocations() {
        let viewController = LocationSearchViewController(coordinator: self)
        if let visibleViewController = navigationController
            .viewControllers.first(where: { $0 is LocationSearchViewControllerDelegate }) {
            viewController.delegate = visibleViewController as? LocationSearchViewControllerDelegate
        }

        navigationController.present(viewController, animated: true)
    }

    func dismiss() {
        navigationController.dismiss(animated: true)
    }

    func presentOfflineView() {
        guard !navigationController.viewControllers
            .contains(where: { $0.view.tag == OfflineViewController.identifier }) else {
            return
        }
        navigationController.pushViewController(OfflineViewController(), animated: false)
    }

    func dismissOfflineView() {
        guard let offlineVCIndex = navigationController.viewControllers
            .firstIndex(where: { $0.view.tag == OfflineViewController.identifier }) else {
            return
        }

        navigationController.viewControllers.remove(at: offlineVCIndex)
    }

    func presentLocationAnimation(isLoading: Bool) {
        if isLoading {
            guard !navigationController.viewControllers
                .contains(where: { $0.view.tag == LottieAnimationViewController.identifier }) else {
                return
            }
            navigationController.pushViewController(LottieAnimationViewController(), animated: false)
        } else {
            guard let index = navigationController.viewControllers
                .firstIndex(where: { $0.view.tag == LottieAnimationViewController.identifier }) else {
                return
            }
            navigationController.viewControllers.remove(at: index)
        }
    }
}
