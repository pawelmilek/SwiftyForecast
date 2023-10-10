import Foundation
import MapKit
import RealmSwift

// swiftlint:disable identifier_name
class LocationModel: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var compoundKey = "name||state||country||postalCode"
    @Persisted var name = ""
    @Persisted var country = ""
    @Persisted var state = ""
    @Persisted var postalCode = ""
    @Persisted var secondsFromGMT = 0
    @Persisted var latitude = 0.0
    @Persisted var longitude = 0.0
    @Persisted var lastUpdate = Date()
    @Persisted var isUserLocation = false

    required override init() {
        super.init()
    }

    convenience init(placemark: CLPlacemark, isUserLocation: Bool = false) {
        self.init()
        name = placemark.locality ?? InvalidReference.notApplicable
        country = placemark.country ?? InvalidReference.notApplicable
        state = placemark.administrativeArea ?? InvalidReference.notApplicable
        postalCode = placemark.postalCode ?? InvalidReference.notApplicable
        latitude = placemark.location?.coordinate.latitude ?? Double.nan
        longitude = placemark.location?.coordinate.longitude ?? Double.nan
        secondsFromGMT = placemark.timeZone?.secondsFromGMT() ?? Int.min
        self.isUserLocation = isUserLocation
        compoundKey = "\(name)||\(state)||\(country)||\(postalCode)".lowercased()
    }
}
