import UIKit

protocol MapCalloutViewControllerDelegate: AnyObject {
  func calloutViewController(didAdd city: CityDTO)
}
