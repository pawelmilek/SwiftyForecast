import UIKit

final class ActivityIndicatorView {
    static let shared = ActivityIndicatorView()

    private let indicatorFrame = CGRect(x: 0, y: 0, width: 55, height: 55)
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView(style: .medium)
        return spinner
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addBlurEffectView(style: .systemUltraThinMaterialLight)
        view.addSubview(activityIndicator)
        return view
    }()

    private var view: UIView? {
        didSet {
            guard let view = view else { return }
            view.addSubview(containerView)

            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: indicatorFrame.size.width).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: indicatorFrame.size.height).isActive = true
        }
    }

    private init() {}
}

// MARK: - Start/Stop indicator
extension ActivityIndicatorView {

    func startAnimating() {
        DispatchQueue.main.async {
            self.view = UIApplication.topViewController?.view
            self.activityIndicator.startAnimating()
        }
    }

    func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
        }
    }

}
