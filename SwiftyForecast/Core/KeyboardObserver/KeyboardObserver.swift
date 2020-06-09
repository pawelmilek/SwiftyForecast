import UIKit

final class KeyboardObserver {
  weak var eventResponder: KeyboardObserverEventResponder? {
    didSet {
      if eventResponder == nil {
        stopObserving()
      }
    }
  }
  
  private var isObserving = false
  
  @objc func keyboardWillShow(notification: Notification) {
    assert(notification.name == UIResponder.keyboardWillShowNotification)
    guard let userInfo = KeyboardUserInfo(notification) else {
      assertionFailure()
      return
    }
    eventResponder?.keyboardWillShow(userInfo)
  }
  
  @objc func keyboardDidShow(notification: Notification) {
    assert(notification.name == UIResponder.keyboardDidShowNotification)
    guard let userInfo = KeyboardUserInfo(notification) else {
      assertionFailure()
      return
    }
    eventResponder?.keyboardDidShow(userInfo)
  }
  
  @objc func keyboardWillHide(notification: Notification) {
    assert(notification.name == UIResponder.keyboardWillHideNotification)
    guard let userInfo = KeyboardUserInfo(notification) else {
      assertionFailure()
      return
    }
    eventResponder?.keyboardWillHide(userInfo)
  }
  
  @objc func keyboardDidHide(notification: Notification) {
    assert(notification.name == UIResponder.keyboardDidHideNotification)
    guard let userInfo = KeyboardUserInfo(notification) else {
      assertionFailure()
      return
    }
    eventResponder?.keyboardDidHide(userInfo)
  }
  
  @objc func keyboardWillChangeFrame(notification: Notification) {
    assert(notification.name == UIResponder.keyboardWillChangeFrameNotification)
    guard let userInfo = KeyboardUserInfo(notification) else {
      assertionFailure()
      return
    }
    eventResponder?.keyboardWillChangeFrame(userInfo)
  }
  
  @objc func keyboardDidChangeFrame(notification: Notification) {
    assert(notification.name == UIResponder.keyboardDidChangeFrameNotification)
    guard let userInfo = KeyboardUserInfo(notification) else {
      assertionFailure()
      return
    }
    eventResponder?.keyboardDidChangeFrame(userInfo)
  }
}

// MARK: - Observer protocol
extension KeyboardObserver: Observer {
  
  func startObserving() {
    if isObserving == true {
      return
    }
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardDidShow),
                                           name: UIResponder.keyboardDidShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardDidHide),
                                           name: UIResponder.keyboardDidHideNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillChangeFrame),
                                           name: UIResponder.keyboardWillChangeFrameNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardDidChangeFrame),
                                           name: UIResponder.keyboardDidChangeFrameNotification,
                                           object: nil)
    isObserving = true
  }
  
  func stopObserving() {
    NotificationCenter.default.removeObserver(self)
    isObserving = false
  }
  
}
