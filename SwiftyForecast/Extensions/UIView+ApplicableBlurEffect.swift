import UIKit

extension UIView {
  
  func addBlurEffectView(style: UIBlurEffect.Style) {
    self.backgroundColor = .clear
    
    let blurEffect = UIBlurEffect(style: style)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.self.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    self.insertSubview(blurEffectView, at: 0)
  }
  
}
