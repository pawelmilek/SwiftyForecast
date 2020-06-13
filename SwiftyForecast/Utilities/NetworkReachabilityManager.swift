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
      let error = error as? ReachabilityError
      error?.handler()
      
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
      debugPrint("Network status changed: Reachability not available!")
      return
    }
    
    switch reachability.connection {
    case .wifi:
      debugPrint("Reachable via WiFi")
      
    case .cellular:
      debugPrint("Reachable via Cellular")
      
    case .unavailable, .none:
      debugPrint("Network not reachable")
    }
  }
  
  func stopNotifier() {
    reachability?.stopNotifier()
  }

}

// MARK: - Network status checkers
extension NetworkReachabilityManager {
  
  func isReachable(completionHandler: @escaping (_ networkReachabilityManager: NetworkReachabilityManager) -> ()) {
    if let reachability = reachability, reachability.connection != .unavailable {
      completionHandler(NetworkReachabilityManager.shared)
    }
  }
  
  func isUnreachable(completionHandler: @escaping (_ networkReachabilityManager: NetworkReachabilityManager) -> ()) {
    if let reachability = reachability, reachability.connection == .unavailable {
      completionHandler(NetworkReachabilityManager.shared)
    }
  }
  
  func isReachableViaWWANCellular(completionHandler: @escaping (_ networkReachabilityManager: NetworkReachabilityManager) -> ()) {
    if let reachability = reachability, reachability.connection == .cellular {
      completionHandler(NetworkReachabilityManager.shared)
    }
  }
  
  func isReachableViaWiFi(completionHandler: @escaping (_ networkReachabilityManager: NetworkReachabilityManager) -> ()) {
    if let reachability = reachability, reachability.connection == .wifi {
      completionHandler(NetworkReachabilityManager.shared)
    }
  }
  
  func whenReachable(completionHandler: @escaping (_ networkReachable: Reachability) -> ()) {
    reachability?.whenReachable = completionHandler
  }
  
  func whenUnreachable(completionHandler: @escaping (_ networkReachable: Reachability) -> ()) {
    reachability?.whenUnreachable = completionHandler
  }
  
}
