import UIKit
import CoreLocation
import SafariServices

@MainActor
final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var topViewController: UIViewController? {
        navigationController.topViewController
    }

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(identifier: MainViewController.storyboardIdentifier) { coder in
            MainViewController(
                viewModel: MainViewControllerViewModel(
                    geocodeLocation: GeocodedLocation(geocoder: CLGeocoder()),
                    notationSystemStore: NotationSystemStore(),
                    measurementSystemNotification: MeasurementSystemNotification(),
                    currentLocationRecord: CurrentLocationRecord(databaseManager: RealmManager.shared),
                    databaseManager: RealmManager.shared,
                    locationManager: LocationManager(),
                    reviewManager: ReviewManager(
                        bundle: .main,
                        storage: .standard,
                        configuration: DecodedPlist(
                            name: "ReviewDesirableMomentConfig",
                            bundle: .main
                        )
                    ),
                    analyticsManager: AnalyticsManager(service: FirebaseAnalyticsService())
                ),
                coordinator: self,
                coder: coder
            )
        }

        navigationController.pushViewController(viewController, animated: false)
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
        let appearanceViewController = AppearanceViewController()
        appearanceViewController.coordinator = self
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

    func popTop() {
        navigationController.popViewController(animated: true)
    }

    func pushOffline() {
        guard !navigationController.viewControllers
            .contains(where: { $0.view.tag == OfflineViewController.identifier }) else {
            return
        }
        navigationController.pushViewController(OfflineViewController(), animated: false)
    }

    func popOffline() {
        guard let offlineVCIndex = navigationController.viewControllers
            .firstIndex(where: { $0.view.tag == OfflineViewController.identifier }) else {
            return
        }

        navigationController.viewControllers.remove(at: offlineVCIndex)
    }

    func timedLocationServicesPrompt() {
        guard let viewController = navigationController.viewControllers.first else { return }

        viewController.navigationItem.prompt = "Please enable location services"
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            viewController.navigationItem.prompt = nil
            self?.navigationController.viewIfLoaded?.setNeedsLayout()
        }

        navigationController.viewIfLoaded?.setNeedsLayout()
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
