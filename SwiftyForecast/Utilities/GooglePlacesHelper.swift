import Foundation
import GooglePlaces

struct GooglePlacesHelper {
  
  static func getCurrentPlace(completionHandler: @escaping (_ place: GMSPlace?, _ error: GooglePlacesError?) -> ()) {
    guard LocationProvider.shared.isLocationServicesEnabled else {
      completionHandler(nil, .locationDisabled)
      return
    }
    
    GMSPlacesClient.shared().currentPlace() { placeLikelihoodList, error in
      guard let place = placeLikelihoodList?.likelihoods.first?.place, error == nil else {
        completionHandler(nil, .placeNotFound)
        return
      }
      
      completionHandler(place, nil)
    }
  }
  
}
