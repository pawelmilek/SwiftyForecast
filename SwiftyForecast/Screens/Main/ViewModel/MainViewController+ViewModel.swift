import UIKit
import RealmSwift
import SafariServices
import CoreLocation
import Combine

extension MainViewController {

    @MainActor
    final class ViewModel: ObservableObject {
        static let userLocationPageIndex = 0
        @Published private(set) var isLoading = false
        @Published private(set) var currentPageIndex = 0
        @Published private(set) var previousPageIndex = 0
        @Published private(set) var currentWeatherViewModels = [CurrentWeatherView.ViewModel]()

        var notationSegmentedControlItems: [String] {
            [TemperatureNotation.fahrenheit.description,
             TemperatureNotation.celsius.description]
        }

        var notationSegmentedControlDefaultIndex: Int {
            NotationController().temperatureNotation.rawValue
        }

        var powerByURL: URL? {
            URL(string: "https://openweathermap.org")
        }

        var numberOfLocations: Int {
            let result = try? locationDAO.read().count
            return result ?? 0
        }

        var currentVisibleWeatherViewModel: CurrentWeatherView.ViewModel {
            return currentWeatherViewModels[currentPageIndex]
        }

        private let repository: Repository
        private let locationDAO: LocationDataAccessObject
        private var token: NotificationToken?

        init(
            repository: Repository,
            locationDAO: LocationDataAccessObject = LocationDataAccessObject()
        ) {
            self.repository = repository
            self.locationDAO = locationDAO

            token = RealmProvider.shared.realm.observe { [weak self] notification, _ in
                switch notification {
                case .didChange:
                    self?.updateViewModelsWhenRealmUpdateOccurred()

                case .refreshRequired:
                    self?.updateViewModelsWhenRealmUpdateOccurred()
                }
            }
        }

        deinit {
            token?.invalidate()
        }

        private func updateViewModelsWhenRealmUpdateOccurred() {
            setCurrentWeatherViewModels()
        }

        private func setCurrentWeatherViewModels() {
            guard let orderedLocations = try? locationDAO.readSorted() else {
                currentWeatherViewModels = []
                return
            }

            let viewModels: [CurrentWeatherView.ViewModel] = orderedLocations.compactMap { [self] in
                    .init(locationModel: $0, repository: repository)
            }

            currentWeatherViewModels = viewModels
        }

        func onUpdateUserLocation(_ location: CLLocation) {
            isLoading.toggle()

            Task(priority: .userInitiated) {
                do {
                    let placemark = try await Geocoder.fetchPlacemark(at: location)
                    let newLocation = createUserLocationModel(by: placemark)

                    try createOrUpdateDatabaseEntry(for: newLocation)
                    onSelectLocation(at: Self.userLocationPageIndex)
                    isLoading.toggle()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }

        private func createUserLocationModel(by placemark: CLPlacemark) -> LocationModel {
            LocationModel(placemark: placemark, isUserLocation: true)
        }

        private func createOrUpdateDatabaseEntry(for location: LocationModel) throws {
            if locationDAO.checkExistanceByCompoundKey(location) {
                try locationDAO.update(location)
            } else {
                try locationDAO.create(location)
            }
        }

        func onSelectLocation(at index: Int) {
            previousPageIndex = currentPageIndex
            currentPageIndex = index
        }

        func temperatureNotationSystemChanged(_ sender: SegmentedControl) {
            currentVisibleWeatherViewModel.onSegmentedControlChange(sender)
            unitSelectionHapticFeedback()
        }

        private func unitSelectionHapticFeedback() {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.selectionChanged()
        }

        func showEnableLocationServicesPrompt(at navigationController: UINavigationController) {
            guard let viewController = navigationController.viewControllers.first else { return }

            viewController.navigationItem.prompt = "Please enable location services"
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                viewController.navigationItem.prompt = nil
                navigationController.viewIfLoaded?.setNeedsLayout()
            }

            navigationController.viewIfLoaded?.setNeedsLayout()
        }
    }

}
