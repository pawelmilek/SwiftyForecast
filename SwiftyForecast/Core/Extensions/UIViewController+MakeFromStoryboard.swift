import UIKit

extension UIViewController: StoryboardIdentifiable {

    static func make<T: UIViewController>(
        _ viewController: T.Type,
        from storyboard: UIStoryboard.Storyboard
    ) -> T {
        let storyboard = UIStoryboard(storyboard: storyboard)
        return storyboard.instantiateViewController(viewController.self)
    }

}
