import Foundation

@objc protocol ViewSetupable: AnyObject {
  func setUp()
  @objc optional func setUpStyle()
}
