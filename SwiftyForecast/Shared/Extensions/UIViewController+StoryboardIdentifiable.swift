import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

// MARK: - Storyboard identifier
extension StoryboardIdentifiable where Self: UIViewController {

    static var storyboardIdentifier: String {
        return String(describing: self)
    }

}
