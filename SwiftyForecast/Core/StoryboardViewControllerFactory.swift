import UIKit

struct StoryboardViewControllerFactory {
  
  static func make<T: UIViewController>(_ vc: T.Type, from storyboard: UIStoryboard.Storyboard = .main) -> T {
    let storyboard = UIStoryboard(storyboard: storyboard)
    return storyboard.instantiateViewController(vc.self)
  }
  
}
