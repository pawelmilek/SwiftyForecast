import UIKit
import SafariServices

@MainActor
final class MainCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = UIViewController.make(MainViewController.self, from: .main)
        viewController.viewModel = MainViewControllerViewModel(service: WeatherService(decoder: JSONDecoder()))
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }

    func openInformationViewController() {
        let sheetViewController = AboutViewController()
        navigationController.present(sheetViewController, animated: true)
    }

    func openAppearanceViewController() {
        let sheetViewController = AppearanceViewController()
        navigationController.present(sheetViewController, animated: true)
    }

    func openLocationListViewController() {
        let viewController = LocationSearchViewController()

        if let visibleViewController = navigationController
            .viewControllers.first(where: { $0 is LocationSearchViewControllerDelegate }) {
            viewController.delegate = visibleViewController as? LocationSearchViewControllerDelegate
        }
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }

    func dismissViewController() {
        navigationController.dismiss(animated: true)
    }

    func popTopViewController() {
        navigationController.popViewController(animated: true)
    }
}
