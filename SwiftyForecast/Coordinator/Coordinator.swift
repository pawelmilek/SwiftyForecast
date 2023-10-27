import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }

    func start()
}
