import UIKit

final class OfflineViewController: UIViewController {
  private let network = NetworkReachabilityManager.shared
  
  private var offLineImageView: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.image = UIImage(named: "ic_offline")
    imageView.contentMode = .scaleToFill
    return imageView
  }()
  
  private var descriptionLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = NSLocalizedString("You are offline, connect to the internet.", comment: "")
    label.font = Style.OfflineVC.descriptionLabelFont
    label.textColor = Style.OfflineVC.descriptionLabelTextColor
    label.textAlignment = Style.OfflineVC.descriptionLabelTextAlignment
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
    setUpStyle()
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

// MARK: - ViewSetupable protocol
extension OfflineViewController: ViewSetupable {
  
  func setUp() {
    network.whenReachable { [weak self] _ in
      self?.showMainViewController()
    }
  }
  
  func setUpLayout() {
    offLineImageView.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    offLineImageView.widthAnchor.constraint(equalToConstant: 240).isActive = true
    offLineImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
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
    view.backgroundColor = Style.OfflineVC.backgroundColor
  }
  
}

// MARK: - Private - Show Main ViewController
extension OfflineViewController {
  
  private func showMainViewController() {
    DispatchQueue.main.async {
      self.navigationController?.popViewController(animated: false)
    }
  }
  
}
