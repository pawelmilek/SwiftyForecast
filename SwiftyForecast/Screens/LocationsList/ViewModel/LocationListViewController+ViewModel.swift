import RealmSwift
import MapKit

extension LocationListViewController {

    @MainActor
    final class ViewModel: ObservableObject {
        @Published private(set) var isInitialLoaded = false
        @Published private(set) var collectionChangeTransaction: CollectionChangeTransaction?

        var numberOfLocations: Int {
            models.count
        }

        private var models: [LocationModel] {
            guard let locationResult = try? locationDAO.readSorted() else { return [] }
            let models: [LocationModel] = locationResult.compactMap { $0 }
            return models
        }

        private let locationDAO: LocationDataAccessObject
        private let locationResult: Results<LocationModel>
        private var realmToken: NotificationToken = NotificationToken()

        init(locationDAO: LocationDataAccessObject = LocationDataAccessObject()) {
            do {
                self.locationDAO = locationDAO
                locationResult = try locationDAO.readSorted()
                realmToken = locationResult.observe { [self] changes in
                    switch changes {
                    case .initial:
                        isInitialLoaded = true

                    case .update(
                        _,
                        deletions: let deletions,
                        insertions: let insertions,
                        modifications: let modifications
                    ):
                        collectionChangeTransaction = CollectionChangeTransaction(
                            deletions: deletions,
                            insertions: insertions,
                            modifications: modifications
                        )

                    case .error(let error):
                        fatalError("File: \(#file), Function: \(#function), line: \(#line) \(error)")
                    }
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }

        func localTime(at index: Int) -> String {
            guard let model = models[safe: index] else { return "" }
            let result = Date.timeOnly(from: model.secondsFromGMT)
            return result
        }

        func name(at index: Int) -> String {
            guard let model = models[safe: index] else { return "" }
            let result = model.name + ", " + model.country
            return result
        }

        func mapPoint(at index: Int) -> (annotation: MKPointAnnotation, region: MKCoordinateRegion)? {
            guard let model = models[safe: index] else { return nil }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude)
            annotation.subtitle = "\(model.name) \(model.state)"

            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            return (annotation: annotation, region: region)
        }

        func delete(at indexPath: IndexPath) {
            guard locationResult.count >= indexPath.row else { return }
            let location = locationResult[indexPath.row]

            do {
                try locationDAO.delete(location)

            } catch {
                fatalError(error.localizedDescription)
            }
        }

        deinit {
            realmToken.invalidate()
        }
    }

}
