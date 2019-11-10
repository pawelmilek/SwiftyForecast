import Foundation
import Reachability

final class NetworkManager {
  static let shared = NetworkManager()
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
private extension NetworkManager {
  
  func registerObserver() {
    ForecastNotificationCenter.add(observer: self,
                                   selector: #selector(networkStatusChanged),
                                   for: .reachabilityChanged,
                                   object: reachability)
  }
  
}

// MARK: - Private - Network status changed
private extension NetworkManager {
  
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
extension NetworkManager {
  
  func isReachable(completionHandler: @escaping (_ networkManager: NetworkManager) -> ()) {
    if let reachability = reachability, reachability.connection != .unavailable {
      completionHandler(NetworkManager.shared)
    }
  }
  
  func isUnreachable(completionHandler: @escaping (_ networkManager: NetworkManager) -> ()) {
    if let reachability = reachability, reachability.connection == .unavailable {
      completionHandler(NetworkManager.shared)
    }
  }
  
  func isReachableViaWWANCellular(completionHandler: @escaping (_ networkManager: NetworkManager) -> ()) {
    if let reachability = reachability, reachability.connection == .cellular {
      completionHandler(NetworkManager.shared)
    }
  }
  
  func isReachableViaWiFi(completionHandler: @escaping (_ networkManager: NetworkManager) -> ()) {
    if let reachability = reachability, reachability.connection == .wifi {
      completionHandler(NetworkManager.shared)
    }
  }
  
  func whenReachable(completionHandler: @escaping (_ networkReachable: Reachability) -> ()) {
    reachability?.whenReachable = completionHandler
  }
  
  func whenUnreachable(completionHandler: @escaping (_ networkReachable: Reachability) -> ()) {
    reachability?.whenUnreachable = completionHandler
  }
  
}
