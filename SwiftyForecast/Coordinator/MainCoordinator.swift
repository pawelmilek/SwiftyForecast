import UIKit
import SafariServices

@MainActor
final class MainCoordinator: Coordinator {
    var topViewController: UIViewController? {
        navigationController.topViewController
    }

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = UIViewController.make(MainViewController.self, from: .main)
        viewController.viewModel = MainViewControllerViewModel(
            service: WeatherService(decoder: JSONSnakeCaseDecoded())
        )
        viewController.coordinator = self
        navigationController.pushViewController(
            viewController,
            animated: false
        )
    }

    func openAboutViewController() {
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

    func pushOfflineViewController() {
        guard !navigationController.viewControllers
            .contains(where: { $0.view.tag == OfflineViewController.identifier }) else {
            return
        }
        navigationController.pushViewController(OfflineViewController(), animated: false)
    }

    func popOfflineViewController() {
        guard let offlineVCIndex = navigationController.viewControllers
            .firstIndex(where: { $0.view.tag == OfflineViewController.identifier }) else {
            return
        }

        navigationController.viewControllers.remove(at: offlineVCIndex)
    }
}
