import UIKit

final class AlertViewPresenter {
    static let shared = AlertViewPresenter()

    private var window: UIWindow!
    private var alertController: UIAlertController!
    private var presentingViewController: UIViewController!

    private init() { }

    func show() {
        DispatchQueue.main.async {
            self.window.makeKeyAndVisible()
            self.window.rootViewController?.present(self.alertController, animated: true)
        }
    }

    func dismiss() {
        DispatchQueue.main.async { [unowned self] in
            self.window.rootViewController?.dismiss(animated: true, completion: nil)
            self.window.rootViewController = nil
            self.window.isHidden = true
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
            self.window = nil
            self.alertController = nil
        }
    }

    func presentError(
        withMessage msg: String,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        window = UIWindow(frame: UIScreen.main.bounds)
        presentingViewController = UIViewController()
        window.rootViewController = presentingViewController
        window.windowLevel = UIWindow.Level.alert + 1

        alertController = UIAlertController(
            title: NSLocalizedString("Error", comment: ""),
            message: msg,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: NSLocalizedString("Ok", comment: ""),
            style: .default
        ) { [self] _ in
            dismiss()
        }
        alertController.addAction(okAction)
        show()
    }

    func presentPopupAlert(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        actionTitles: [String] = ["OK"],
        actions: [((UIAlertAction) -> Void)?] = [nil]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}
