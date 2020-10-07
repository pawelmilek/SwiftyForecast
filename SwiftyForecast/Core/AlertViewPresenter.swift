import UIKit

final class AlertViewPresenter { }

// MARK: - Present submit Alert
extension AlertViewPresenter {
  
  static func presentSubmitAlert(in viewController: UIViewController,
                                 title: String,
                                 message: String,
                                 textFieldConfiguration: ((UITextField) -> ())? = nil,
                                 submitCompletionHandler: @escaping ((String) -> ())) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addTextField(configurationHandler: textFieldConfiguration)
    
    let submitAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                     style: .default, handler: { action in
                                      guard let textField = alert.textFields?.first, let text = textField.text else { return }
                                      submitCompletionHandler(text)
    })
    
    let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                               style: .destructive)
    
    alert.addAction(submitAction)
    alert.addAction(cancel)
    viewController.present(alert, animated: true)
  }
  
}

// MARK: - Present Error Alert
extension AlertViewPresenter {
  
  static func presentError(withMessage msg: String, animated: Bool = true, completion: (() -> Void)? = nil) {
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    let viewController = UIViewController()
    viewController.view.backgroundColor = .clear
    alertWindow.rootViewController = viewController
    alertWindow.windowLevel = UIWindow.Level.alert + 1
    alertWindow.makeKeyAndVisible()
    
    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: msg, preferredStyle: .alert)
    let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default)
    alert.addAction(okAction)
    
    viewController.present(alert, animated: animated, completion: completion)
  }
  
}

// MARK: - Present Popup Alert
extension AlertViewPresenter {
  
  static func presentPopupAlert(in viewController: UIViewController,
                                title: String?,
                                message: String?,
                                actionTitles: [String] = ["OK"],
                                actions: [((UIAlertAction) -> ())?] = [nil]) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    for (index, title) in actionTitles.enumerated() {
      let action = UIAlertAction(title: title, style: .default, handler: actions[index])
      alert.addAction(action)
    }
    viewController.present(alert, animated: true, completion: nil)
  }
  
}
