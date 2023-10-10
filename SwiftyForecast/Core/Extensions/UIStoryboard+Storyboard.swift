import UIKit

extension UIStoryboard {

  enum Storyboard: String {
    case main = "Main"

    var fileName: String {
      return rawValue
    }
  }

  convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
    self.init(name: storyboard.fileName, bundle: bundle)
  }

  func instantiateViewController<T: UIViewController>(_ viewController: T.Type) -> T {
      guard let viewController = self.instantiateViewController(
        withIdentifier: viewController.storyboardIdentifier
      ) as? T else {
      fatalError("Couldn't instantiate view controller with identifier \(viewController.storyboardIdentifier) ")
    }

    return viewController
  }

}
