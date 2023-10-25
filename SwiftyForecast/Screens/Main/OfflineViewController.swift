import UIKit

final class OfflineViewController: UIViewController {
    static let identifier = 0xDEADBEEF

    private var offLineImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage.icOffline
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("You are offline", comment: "")
        label.font = Style.Offline.descriptionFont
        label.textColor = Style.Offline.descriptionColor
        label.textAlignment = Style.Offline.descriptionAlignment
        label.numberOfLines = 1
        return label
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        return stackView
    }()

    override func loadView() {
        super.loadView()
        setUpLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
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

// MARK: - Private - SetUps
private extension OfflineViewController {

    func setUp() {
        self.view.tag = OfflineViewController.identifier
        setUpStyle()
    }

    func setUpLayout() {
        offLineImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        offLineImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        offLineImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true

        stackView.addArrangedSubview(offLineImageView)
        stackView.addArrangedSubview(descriptionLabel)

        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        view.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
    }

    func setUpStyle() {
        view.backgroundColor = Style.Offline.backgroundColor
    }

}
