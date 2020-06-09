import UIKit

extension UIViewController {
  
  func addKeyboardDismissGestureRecognizer() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc func hideKeyboard() {
    view.endEditing(true)
  }

}
