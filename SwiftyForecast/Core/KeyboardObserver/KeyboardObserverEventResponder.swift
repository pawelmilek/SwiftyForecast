import Foundation

protocol KeyboardObserverEventResponder: class {
  func keyboardWillShow(_ userInfo: KeyboardUserInfo)
  func keyboardDidShow(_ userInfo: KeyboardUserInfo)
  func keyboardWillHide(_ userInfo: KeyboardUserInfo)
  func keyboardDidHide(_ userInfo: KeyboardUserInfo)
  func keyboardWillChangeFrame(_ userInfo: KeyboardUserInfo)
  func keyboardDidChangeFrame(_ userInfo: KeyboardUserInfo)
}

// MARK: - Default implementation allows this protocol method to be optional
extension KeyboardObserverEventResponder {
  func keyboardWillShow(_ userInfo: KeyboardUserInfo) { }
  func keyboardDidShow(_ userInfo: KeyboardUserInfo) { }
  func keyboardWillHide(_ userInfo: KeyboardUserInfo) { }
  func keyboardDidHide(_ userInfo: KeyboardUserInfo) { }
  func keyboardWillChangeFrame(_ userInfo: KeyboardUserInfo) { }
  func keyboardDidChangeFrame(_ userInfo: KeyboardUserInfo) { }
}
