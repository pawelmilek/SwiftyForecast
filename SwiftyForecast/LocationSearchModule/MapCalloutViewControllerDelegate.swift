import UIKit

protocol MapCalloutViewControllerDelegate: class {
  func calloutViewController(didAdd city: CityDTO)
}
