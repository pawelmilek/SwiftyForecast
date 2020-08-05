import UIKit
import MapKit

final class CityAnnotationView: MKAnnotationView {
  private var customCalloutView: CityCalloutView?
  weak var restaurantDetailDelegate: CityCalloutViewDelegate?
  var isHiddenShowDetailsButton = false
  
  private lazy var mapPinImage: UIImage = {
    let pinImage = UIImage(named: "ic_mapsPin")
    let size = CGSize(width: 40, height: 40)
    UIGraphicsBeginImageContext(size)
    pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return pinImage!
  }()
  
  override var annotation: MKAnnotation? {
    willSet {
      customCalloutView?.removeFromSuperview()
    }
  }
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    self.canShowCallout = false
    self.image = mapPinImage
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.canShowCallout = false
    self.image = mapPinImage
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    customCalloutView?.removeFromSuperview()
  }
  
  // MARK: - callout showing and hiding
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    let animationTime = 0.5
    if selected {
      customCalloutView?.removeFromSuperview()
      
      if let newCustomCalloutView = loadRestaurantDetailMapView() {
        // fix location from top-left to its right place.
        newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
        newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
        
        // set custom callout view
        addSubview(newCustomCalloutView)
        customCalloutView = newCustomCalloutView
        
        // animate presentation
        if animated {
          customCalloutView!.alpha = 0.0
          UIView.animate(withDuration: animationTime, animations: {
            self.customCalloutView!.alpha = 1.0
          })
        }
      }
    } else {
      if customCalloutView != nil {
        if animated { // fade out animation, then remove it.
          UIView.animate(withDuration: animationTime, animations: {
            self.customCalloutView!.alpha = 0.0
          }, completion: { (success) in
            self.customCalloutView!.removeFromSuperview()
          })
        } else {
          customCalloutView!.removeFromSuperview()
        }
      }
    }
  }
  
  
  func loadRestaurantDetailMapView() -> CityCalloutView? {
    guard let cityCalloutView = Bundle.main.loadNibNamed(CityCalloutView.nibName, owner: self, options: nil)?.first as? CityCalloutView else { return nil }
    
    cityCalloutView.showDetailsButton.isHidden = isHiddenShowDetailsButton
    cityCalloutView.delegate = self.restaurantDetailDelegate
    
    if let _ = annotation as? CityAnnotation, let city = cityCalloutView.city {
      cityCalloutView.configure(by: city)
    }
    return cityCalloutView
    
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    // if super passed hit test, return the result
    if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
    else { // test in our custom callout.
      if customCalloutView != nil {
        return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
      } else { return nil }
    }
  }
  
}
