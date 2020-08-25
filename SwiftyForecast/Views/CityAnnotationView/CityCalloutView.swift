import UIKit

final class CustomCalloutView: UIView {
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  weak var delegate: CityCalloutViewDelegate?
  var city: City? {
    didSet {
      //      guard let restaurant = restaurant else { return }
      //      nameLabel.text = restaurant.name
      //      streetLabel.text = restaurant.location.street
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setUp()
    setUpStyle()
  }
  
  // MARK: - Hit test. We need to override this to detect hits in our custom callout.
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    // Check if it hit our annotation detail view components.
    if let result = openMapDirectionButton.hitTest(convert(point, to: openMapDirectionButton), with: event) {
      return result
    }
    
    if let result = addButton.hitTest(convert(point, to: addButton), with: event) {
      return result
    }
    
    // fallback to our background content view
    return contentButton.hitTest(convert(point, to: contentButton), with: event)
  }
}


// MARK: - ViewSetupable protocol
extension CustomCalloutView: ViewSetupable {
  
  func setUp() {
    self.layer.cornerRadius = 10
  }
  
  func setUpStyle() {
    typealias DetailMapViewStyle = Style.CityCallout
    backgroundColor = DetailMapViewStyle.defaultBackgroundColor
    
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


// MARK: Configure
extension CustomCalloutView {
  
  func configure(by city: City) {
    self.city = city
  }
  
}


// MARK: - Actions
extension CustomCalloutView {
  
  @IBAction func addCityButtonTapped(_ sender: UIButton) {
    delegate?.cityCalloutView(self, didPressAdd: sender)
  }
  
}
