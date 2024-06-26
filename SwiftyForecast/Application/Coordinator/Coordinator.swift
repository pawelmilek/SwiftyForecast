import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }

    func start()
    func openAbout()
    func openAppearanceSwitch()
    func openLocations()
    func dismiss()
    func presentOfflineView()
    func dismissOfflineView()
    func presentLocationAnimation(isLoading: Bool)
}
