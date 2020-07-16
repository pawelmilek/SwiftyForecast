import UIKit
import SafariServices

protocol ForecastViewControllerDelegate: class {
  func forecastViewController(_ viewController: ForecastViewController, didTapSelectionBarButton: UIBarButtonItem)
  func forecastViewController(_ viewController: ForecastViewController, didTapPoweredByBarButton: UIBarButtonItem)
  
}

protocol SwiftyForecastCoordinatorDelegate: class {

}

final class SwiftyForecastCoordinator: ForecastViewControllerDelegate {
  weak var delegate: SwiftyForecastCoordinatorDelegate?
  private let navigationController: UINavigationController

  init(navigationController: UINavigationController) {
      self.navigationController = navigationController
  }
}

// MARK: - SwiftyForecastCoordinator delegate
extension SwiftyForecastCoordinator {
  
  func forecastViewController(_ viewController: ForecastViewController, didTapSelectionBarButton: UIBarButtonItem) {
//    viewController.delegate = self

    let citySelectionViewController = CitySelectionViewController.make()
    citySelectionViewController.viewModel = DefaultCitySelectionViewModel(delegate: citySelectionViewController)
    citySelectionViewController.delegate = viewController
    citySelectionViewController.modalPresentationStyle = .fullScreen
    navigationController.present(citySelectionViewController, animated: true)
  }
  
  func forecastViewController(_ viewController: ForecastViewController, didTapPoweredByBarButton: UIBarButtonItem) {
//    viewController.delegate = self
    
    if let url = URL(string: "https://darksky.net/poweredby/") {
      let safariViewController = SFSafariViewController(url: url)
      navigationController.present(safariViewController, animated: true)
    }
  }
  
}
