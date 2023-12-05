import UIKit

extension UIApplication {

    class var topViewController: UIViewController? {
        guard let window = UIApplication.shared.keyWindow,
              let rootViewController = window.rootViewController else {
            return nil
        }

        var topController = rootViewController
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }

        return topController
    }

}
