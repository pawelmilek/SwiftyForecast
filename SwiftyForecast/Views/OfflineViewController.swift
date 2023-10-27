import UIKit

final class OfflineViewController: UIViewController {
    static let identifier = 0xDEADBEEF

    private var centerImageView: UIImageView = {
        let imageView = UIImageView()
        var config = UIImage.SymbolConfiguration(
            font: Style.Offline.symbolFont,
            scale: .large
        )
        imageView.image = UIImage(systemName: "wifi.slash", withConfiguration: config)
        imageView.tintColor = Style.Offline.symbolColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("You are offline", comment: "")
        label.font = Style.Offline.descriptionFont
        label.textColor = Style.Offline.descriptionColor
        label.textAlignment = Style.Offline.descriptionAlignment
        label.numberOfLines = 1
        return label
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()

    override func loadView() {
        super.loadView()
        setupLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Private - Setups
private extension OfflineViewController {

    func setup() {
        self.view.tag = OfflineViewController.identifier
        view.backgroundColor = Style.Offline.backgroundColor
    }

    func setupLayout() {
        stackView.addArrangedSubview(centerImageView)
        stackView.addArrangedSubview(descriptionLabel)
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            view.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])
    }
}

#Preview {
    OfflineViewController()
}
