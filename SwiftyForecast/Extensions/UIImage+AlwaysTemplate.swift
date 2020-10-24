import UIKit

extension UIImage {
  
  static func makeAlwaysTemplate(named: String) -> UIImage? {
    let origImage = UIImage(named: named)
    return origImage?.withRenderingMode(.alwaysTemplate)
  }
  
}
