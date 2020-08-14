import UIKit
import MapKit

final class CityTableViewCell: UITableViewCell {
  static let defaultHeight = CGFloat(160)

  @IBOutlet private weak var currentTimeLabel: UILabel!
  @IBOutlet private weak var cityNameLabel: UILabel!
  @IBOutlet private weak var separatorView: UIView!
  @IBOutlet private weak var mapView: MKMapView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setUp()
    setUpStyle()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    setUp()
  }
}

// MARK: - Private - SetUps
private extension CityTableViewCell {
  
  func setUp() {
    currentTimeLabel.text = ""
    currentTimeLabel.alpha = 0
    cityNameLabel.text = ""
    cityNameLabel.alpha = 0
    mapView.removeAnnotations(mapView.annotations)
    mapView.isUserInteractionEnabled = false
    mapView.showsUserLocation = false
    mapView.layer.cornerRadius = 15
  }
  
  func setUpStyle() {
    backgroundColor = Style.CityCell.backgroundColor
    selectionStyle = .none
    
    currentTimeLabel.font = Style.CityCell.currentTimeLabelFont
    currentTimeLabel.textColor = Style.CityCell.currentTimeLabelTextColor
    currentTimeLabel.textAlignment = Style.CityCell.currentTimeLabelTextAlignment
    
    cityNameLabel.font = Style.CityCell.cityNameLabelFont
    cityNameLabel.textColor = Style.CityCell.cityNameLabelTextColor
    cityNameLabel.textAlignment = Style.CityCell.cityNameLabelTextAlignment
    separatorView.backgroundColor = Style.CityCell.separatorColor
  }
  
}

// MARK: - Configure by city
extension CityTableViewCell {

  func configure(by name: String,
                 time localTime: String,
                 annotation: MKPointAnnotation?,
                 region: MKCoordinateRegion?) {
    currentTimeLabel.text = localTime
    cityNameLabel.text = name
    currentTimeLabel.alpha = 1
    cityNameLabel.alpha = 1

    if let annotation = annotation, let region = region {
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: false)
    }
  }

}
