import UIKit
import MapKit

final class AddCalloutViewController: UIViewController, ErrorHandleable {
  @IBOutlet private weak var addButton: UIButton!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var subtitleLabel: UILabel!
  
  private var viewModel: AddCalloutViewModel?
  private weak var delegate: AddCalloutViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
    setUpStyle()
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.preferredContentSize = self.view.systemLayoutSizeFitting (
          UIView.layoutFittingCompressedSize
      )
  }
  
  deinit {
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) deinit AddCalloutViewController")
  }
}

// MARK: Configure
extension AddCalloutViewController {
  
  func configure(viewModel: AddCalloutViewModel, delegate: AddCalloutViewControllerDelegate) {
    self.viewModel = viewModel
    self.delegate = delegate
  }
  
}

// MARK: - Private - SetUp
private extension AddCalloutViewController {
  
  func setUp() {
    setLabels()
    setButton()
  }
  
  func setLabels() {
    titleLabel.text = viewModel?.cityName
    subtitleLabel.text = viewModel?.country
  }
  
  func setButton() {
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
  }
  
  func setUpStyle() {
    view.backgroundColor = Style.AddCalloutView.defaultBackgroundColor
    view.layer.cornerRadius = Style.AddCalloutView.cornerRadius
    
    titleLabel.font = Style.AddCalloutView.titleLabelFont
    titleLabel.textColor = Style.AddCalloutView.titleLabelTextColor
    titleLabel.textAlignment = Style.AddCalloutView.titleLabelAlignment
    titleLabel.numberOfLines = Style.AddCalloutView.titleLabelNumberOfLines
    
    subtitleLabel.font = Style.AddCalloutView.subtitleLabelFont
    subtitleLabel.textColor = Style.AddCalloutView.subtitleLabelTextColor
    subtitleLabel.textAlignment = Style.AddCalloutView.subtitleLabelAlignment
    subtitleLabel.numberOfLines = Style.AddCalloutView.subtitleLabelNumberOfLines
    
    let image = UIImage.makeAlwaysTemplate(named: Style.AddCalloutView.addButtonIconName)
    addButton.setBackgroundImage(image, for: .normal)
    addButton.tintColor = Style.AddCalloutView.addButtonTintColor
  }

}

// MARK: - Actions
private extension AddCalloutViewController {

  @objc func addButtonTapped(_ sender: UIButton) {
    viewModel?.add { result in
      switch result {
      case .success:
        delegate?.addCalloutViewController(self, didPressAdd: sender)
        
      case .failure(let error):
        error.handler()
      }
    }
  }
  
}

// MARK: - Factory method
extension AddCalloutViewController {
  
  static func make(viewModel: AddCalloutViewModel, delegate: AddCalloutViewControllerDelegate) -> AddCalloutViewController {
    let viewController = StoryboardViewControllerFactory.make(AddCalloutViewController.self, from: .locationSearch)
    viewController.configure(viewModel: viewModel, delegate: delegate)
    return viewController
  }
}
