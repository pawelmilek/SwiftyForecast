import UIKit

extension UIStoryboard {
  
  enum Storyboard: String {
    case main
    
    var fileName: String {
      return rawValue.capitalized
    }
  }
  
  convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
    self.init(name: storyboard.fileName, bundle: bundle)
  }
  
  func instantiateViewController<T: UIViewController>(_ vc: T.Type) -> T {
    guard let viewController = self.instantiateViewController(withIdentifier: vc.storyboardIdentifier) as? T else {
      fatalError("Couldn't instantiate view controller with identifier \(vc.storyboardIdentifier) ")
    }
    
    return viewController
  }
  
}
