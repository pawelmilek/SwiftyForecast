import UIKit
import SafariServices

final class MainCoordinator: Coordinator {
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewController = ForecastViewController.make()
    viewController.viewModel = DefaultForecastViewModel(service: DefaultForecastService())
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: false)
  }
  
  func onTapPoweredByBarButton() {
    if let url = URL(string: "https://darksky.net/poweredby/") {
      let safariViewController = SFSafariViewController(url: url)
      navigationController.present(safariViewController, animated: true)
    }
  }
  
  func onTapCitySelectionBarButton() {
    let viewController = CitySelectionViewController.make()
    viewController.coordinator = self
    viewController.viewModel = DefaultCitySelectionViewModel(delegate: viewController)
    
    if let forecastViewController = navigationController.viewControllers.first(where: { $0 is CitySelectionViewControllerDelegate }) {
      viewController.delegate = forecastViewController as? CitySelectionViewControllerDelegate
    }
    
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func onSelectCityFromAvailableCollection() {
    navigationController.popViewController(animated: true)
  }
  
  func onAddNewCity() {
    let viewController = SearchLocationViewController.make()
    viewController.coordinator = self

    navigationController.pushViewController(viewController, animated: true)
  }
}
