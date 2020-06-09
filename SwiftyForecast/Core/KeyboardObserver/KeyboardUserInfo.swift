import UIKit

struct KeyboardUserInfo {
  let animationCurve: UIView.AnimationCurve
  let animationDuration: Double
  let isLocal: Bool
  let beginFrame: CGRect
  let endFrame: CGRect
  
  let animationCurveKey = UIResponder.keyboardAnimationCurveUserInfoKey
  let animationDurationKey = UIResponder.keyboardAnimationDurationUserInfoKey
  let isLocalKey = UIResponder.keyboardIsLocalUserInfoKey
  let frameBeginKey = UIResponder.keyboardFrameBeginUserInfoKey
  let frameEndKey = UIResponder.keyboardFrameEndUserInfoKey
  
  init?(_ notification: Notification) {
    guard let userInfo = notification.userInfo else { return nil }
    
    guard let animationCurveUserInfo = userInfo[animationCurveKey],
      let animationCurveRaw = animationCurveUserInfo as? Int,
      let animationCurve = UIView.AnimationCurve(rawValue: animationCurveRaw) else {
        return nil
    }
    self.animationCurve = animationCurve
    
    guard let animationDurationUserInfo = userInfo[animationDurationKey],
      let animationDuration = animationDurationUserInfo as? Double else {
        return nil
    }
    self.animationDuration = animationDuration
    
    guard let isLocalUserInfo = userInfo[isLocalKey], let isLocal = isLocalUserInfo as? Bool else { return nil }
    self.isLocal = isLocal
    
    guard let beginFrameUserInfo = userInfo[frameBeginKey], let beginFrame = beginFrameUserInfo as? CGRect else { return nil }
    self.beginFrame = beginFrame
    
    guard let endFrameUserInfo = userInfo[frameEndKey], let endFrame = endFrameUserInfo as? CGRect else { return nil }
    self.endFrame = endFrame
  }
}
