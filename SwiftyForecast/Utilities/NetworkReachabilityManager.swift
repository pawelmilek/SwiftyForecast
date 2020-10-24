import Foundation
import Reachability

final class NetworkReachabilityManager {
  static let shared = NetworkReachabilityManager()
  private let reachability: Reachability?
  
  private init() {
    reachability = try? Reachability()
    do {
      registerObserver()
      try reachability?.startNotifier()

    } catch let error where error is ReachabilityError {
      (error as? ReachabilityError)?.handler()

    } catch let error {
      AlertViewPresenter.presentError(withMessage: error.localizedDescription)
    }
  }
}

// MARK: - Private - Register observer
private extension NetworkReachabilityManager {
  
  func registerObserver() {
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(networkStatusChanged),
                                   for: .reachabilityChanged,
                                   object: reachability)
  }
  
}

// MARK: - Private - Network status changed
private extension NetworkReachabilityManager {
  
  @objc func networkStatusChanged(_ notification: Notification) {
    guard let reachability = notification.object as? Reachability else {
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) Network status changed: Reachability not available")
      return
    }
    
    switch reachability.connection {
    case .wifi:
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) Reachable via WiFi")
      
    case .cellular:
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) Reachable via Cellular")
      
    case .unavailable, .none:
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) Network not reachable")
    }
  }
  
  func stopNotifier() {
    reachability?.stopNotifier()
  }

}

// MARK: - Network status checkers
extension NetworkReachabilityManager {
  
  func isReachable(completion: @escaping () -> Void) {
    if let reachability = reachability, reachability.connection != .unavailable {
      completion()
    }
  }
  
  func isUnreachable(completion: @escaping () -> Void) {
    if let reachability = reachability, reachability.connection == .unavailable {
      completion()
    }
  }
  
  func isReachableViaWWANCellular(completion: @escaping () -> Void) {
    if let reachability = reachability, reachability.connection == .cellular {
      completion()
    }
  }
  
  func isReachableViaWiFi(completion: @escaping () -> Void) {
    if let reachability = reachability, reachability.connection == .wifi {
      completion()
    }
  }
  
  func whenReachable(completionHandler: @escaping (_ networkReachable: Reachability) -> ()) {
    reachability?.whenReachable = completionHandler
  }
  
  func whenUnreachable(completionHandler: @escaping (_ networkReachable: Reachability) -> ()) {
    reachability?.whenUnreachable = completionHandler
  }
  
}
