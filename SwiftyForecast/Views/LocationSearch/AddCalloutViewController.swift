import UIKit
import MapKit

protocol AddCalloutViewControllerDelegate: class {
  func addCalloutViewController(_ view: AddCalloutViewController, didPressAdd button: UIButton)
}

final class AddCalloutViewController: UIViewController {
  @IBOutlet private weak var addButton: UIButton!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var subtitleLabel: UILabel!
  
  private weak var delegate: AddCalloutViewControllerDelegate?
  private var city: City?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
    setUpStyle()
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.preferredContentSize = self.view.systemLayoutSizeFitting(
          UIView.layoutFittingCompressedSize
      )
  }
}

// MARK: Configure
extension AddCalloutViewController {
  
  func configure(placemark: MKPlacemark, delegate: AddCalloutViewControllerDelegate) {
    self.city = City(placemark: placemark)
    self.delegate = delegate
  }
  
}

// MARK: - Private - SetUp
private extension AddCalloutViewController {
  
  func setUp() {
    titleLabel.text = city?.name
    subtitleLabel.text = city?.country
    
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
  }
  
  func setUpStyle() {
    typealias DetailMapViewStyle = Style.CityCallout
    view.backgroundColor = DetailMapViewStyle.defaultBackgroundColor
    
    titleLabel.font = DetailMapViewStyle.nameLabelFont
    titleLabel.textColor = DetailMapViewStyle.nameLabelTextColor
    titleLabel.textAlignment = DetailMapViewStyle.nameLabelAlignment
    titleLabel.numberOfLines = DetailMapViewStyle.nameLabelNumberOfLines
    
    subtitleLabel.font = DetailMapViewStyle.streetLabelFont
    subtitleLabel.textColor = DetailMapViewStyle.streetLabelTextColor
    subtitleLabel.textAlignment = DetailMapViewStyle.streetLabelAlignment
    subtitleLabel.numberOfLines = DetailMapViewStyle.streetLabelNumberOfLines
    
    let origImage = UIImage(named: "ic_add")
    let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
    addButton.setBackgroundImage(tintedImage, for: .normal)
    addButton.tintColor = .orange
    
    view.layer.borderColor = UIColor.orange.cgColor
    view.layer.masksToBounds = true
    view.layer.borderWidth = 1
    view.layer.cornerRadius = 15
  }

}

// MARK: - Actions
private extension AddCalloutViewController {
  
  @objc func addButtonTapped(_ sender: UIButton) {
    delegate?.addCalloutViewController(self, didPressAdd: sender)
  }
  
}
