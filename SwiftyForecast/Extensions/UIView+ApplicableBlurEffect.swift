import UIKit

extension UIView {
  
  func addBlurEffectView(style: UIBlurEffect.Style) {
    backgroundColor = .clear
    
    let blurEffect = UIBlurEffect(style: style)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    blurEffectView.frame = bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(blurEffectView)
  }
  
}
