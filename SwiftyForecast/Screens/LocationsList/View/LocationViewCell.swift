import UIKit
import MapKit

final class LocationViewCell: UITableViewCell {
    static let defaultHeight = CGFloat(160)

    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var mapView: MKMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setUp()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpStyle()
    }

    func configure(
        by name: String,
        time localTime: String,
        mapPoint: (annotation: MKPointAnnotation, region: MKCoordinateRegion)?
    ) {
        currentTimeLabel.text = localTime
        cityNameLabel.text = name

        if let mapPoint {
            mapView.addAnnotation(mapPoint.annotation)
            mapView.setRegion(mapPoint.region, animated: false)
            mapView.layoutIfNeeded()
        }
    }
}

// MARK: - Private - SetUps
private extension LocationViewCell {

    func setUp() {
        currentTimeLabel.text = ""
        cityNameLabel.text = ""
        mapView.removeAnnotations(mapView.annotations)
        mapView.isUserInteractionEnabled = false
        mapView.showsUserLocation = false
        mapView.layer.cornerRadius = 15
    }

    func setUpStyle() {
        backgroundColor = Style.LocationListRow.backgroundColor
        selectionStyle = .none

        currentTimeLabel.font = Style.LocationListRow.timeFont
        currentTimeLabel.textColor = Style.LocationListRow.timeColor
        currentTimeLabel.textAlignment = Style.LocationListRow.timeAlignment

        cityNameLabel.font = Style.LocationListRow.locationNameFont
        cityNameLabel.textColor = Style.LocationListRow.locationNameColor
        cityNameLabel.textAlignment = Style.LocationListRow.locationNameAlignment
        separatorView.backgroundColor = Style.LocationListRow.separatorColor

        mapView.layer.borderColor = UIColor.primary.cgColor
        mapView.layer.borderWidth = 0.5
    }

}
