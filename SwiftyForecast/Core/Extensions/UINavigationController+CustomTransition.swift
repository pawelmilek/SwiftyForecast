import UIKit

extension UINavigationController {

    func pop(transitionType type: CATransitionType,
             transitionSubtype subtype: CATransitionSubtype,
             duration: CFTimeInterval = 0.3) {
        DispatchQueue.main.async {
            self.addTransition(transitionType: type, transitionSubtype: subtype, duration: duration)
            self.popViewController(animated: false)
        }
    }

    func push(viewController: UIViewController,
              transitionType type: CATransitionType,
              transitionSubtype subtype: CATransitionSubtype,
              duration: CFTimeInterval = 0.3) {
        DispatchQueue.main.async {
            self.addTransition(transitionType: type, transitionSubtype: subtype, duration: duration)
            self.pushViewController(viewController, animated: false)
        }
    }

    private func addTransition(transitionType type: CATransitionType,
                               transitionSubtype subtype: CATransitionSubtype,
                               duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = type
        transition.subtype = subtype
        self.view.layer.add(transition, forKey: nil)
    }

}
