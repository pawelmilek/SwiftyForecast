import UIKit
import SafariServices

final class MainCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    @MainActor
    func start() {
        let viewController = MainViewController.make()
        let service = WeatherService()
        let repository = WeatherRepository(service: service)
        viewController.viewModel = MainViewController.ViewModel(repository: repository)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }

    @MainActor
    func openWeatherAPISoruceWebPage(url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        navigationController.present(safariViewController, animated: true)
    }

    @MainActor
    func openLocationListViewController() {
        let viewController = LocationListViewController.make()
        viewController.viewModel = LocationListViewController.ViewModel()

        if let forecastViewController = navigationController.viewControllers
            .first(where: { $0 is LocationListViewControllerDelegate }) {
            viewController.delegate = forecastViewController as? LocationListViewControllerDelegate
        }

        navigationController.push(
            viewController: viewController,
            transitionType: .moveIn,
            transitionSubtype: .fromTop
        )
    }

    @MainActor
    func openLocationSearchViewController() {
        let viewController = LocationSearchViewController()
        navigationController.present(viewController, animated: true)
    }

    @MainActor
    func popTopViewControllerFromBottom() {
        navigationController.pop(transitionType: .reveal, transitionSubtype: .fromBottom)
    }

    @MainActor
    func popTopViewController() {
        navigationController.popViewController(animated: true)
    }
}
