import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }

    func start()
    func openAboutViewController()
    func openAppearanceViewController()
    func openLocationListViewController()
    func dismissViewController()
    func popTopViewController()
    func pushOfflineViewController()
    func popOfflineViewController()
}
