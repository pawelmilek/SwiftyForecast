import UIKit

extension UIApplication {
  
  class var topViewController: UIViewController? {
        guard let window = UIApplication.shared.sceneKeyWindow,
      let rootViewController = window.rootViewController else {
        return nil
    }
    
    var topController = rootViewController
    while let newTopController = topController.presentedViewController {
      topController = newTopController
    }
    
    return topController
  }
  
  var sceneKeyWindow: UIWindow? {
      return windows.first(where: { $0.isKeyWindow })
  }
  
}
