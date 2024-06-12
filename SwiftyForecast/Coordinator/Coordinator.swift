import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func openAbout()
    func openAppearanceSwitch()
    func openLocations()
    func dismiss()
    func popTop()
    func pushOffline()
    func popOffline()
    func timedLocationServicesPrompt()
}
