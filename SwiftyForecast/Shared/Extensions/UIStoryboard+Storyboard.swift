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

}
