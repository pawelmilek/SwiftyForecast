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
  
  func onTapCityListSelectionBarButton() {
    let viewController = CityListSelectionViewController.make()
    viewController.coordinator = self
    viewController.viewModel = DefaultCityListViewModel(delegate: viewController)
    
    if let forecastViewController = navigationController.viewControllers.first(where: { $0 is CityListSelectionViewControllerDelegate }) {
      viewController.delegate = forecastViewController as? CityListSelectionViewControllerDelegate
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
  
  func onAddCityFromCalloutViewController() {
    navigationController.popViewController(animated: true)
  }
}
