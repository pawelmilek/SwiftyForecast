import UIKit
import MapKit

final class MapCalloutViewController: UIViewController, ErrorHandleable {
  @IBOutlet private weak var addButton: UIButton!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var subtitleLabel: UILabel!
  
  private var viewModel: MapCalloutViewModel?
  
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
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) deinit MapCalloutViewController")
  }
}

// MARK: Configure view controller
extension MapCalloutViewController {
  
  func configure(viewModel: MapCalloutViewModel) {
    self.viewModel = viewModel
  }
  
}

// MARK: - Private - SetUp
private extension MapCalloutViewController {
  
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
private extension MapCalloutViewController {

  @objc func addButtonTapped(_ sender: UIButton) {
    viewModel?.addCityToLocationList()
  }
  
}

// MARK: - Factory method
extension MapCalloutViewController {
  
  static func make(viewModel: MapCalloutViewModel) -> MapCalloutViewController {
    let viewController = StoryboardViewControllerFactory.make(MapCalloutViewController.self, from: .locationSearch)
    viewController.configure(viewModel: viewModel)
    return viewController
  }
  
}
