import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var databaseManager: DatabaseManager { get }

    func start()
    func openAbout()
    func openAppearanceSwitch()
    func openLocations()
    func dismiss()
    func presentOfflineView()
    func dismissOfflineView()
    func timedLocationServicesPrompt()
    func presentLocationAnimation(isLoading: Bool)
}
