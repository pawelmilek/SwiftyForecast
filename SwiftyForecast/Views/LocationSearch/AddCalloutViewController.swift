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
  }

}

// MARK: - Actions
private extension AddCalloutViewController {
  
  @objc func addButtonTapped(_ sender: UIButton) {
    delegate?.addCalloutViewController(self, didPressAdd: sender)
  }
  
}
