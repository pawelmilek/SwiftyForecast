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
  
  func onTapPoweredByBarButton(url: URL?) {
    if let url = url {
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

    navigationController.push(viewController: viewController, transitionType: .moveIn, transitionSubtype: .fromTop)
  }
  
  func onSelectCityFromAvailableCollection() {
    navigationController.pop(transitionType: .reveal, transitionSubtype: .fromBottom)
  }
  
  func onSearchLocation() {
    let viewController = LocationSearchViewController.make()
    viewController.coordinator = self
    
    navigationController.pushViewController(viewController, animated: true)
  }
}
