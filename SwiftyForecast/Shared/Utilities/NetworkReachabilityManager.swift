import Foundation
import Reachability

final class NetworkReachabilityManager {
    static let shared = NetworkReachabilityManager()
    private let reachability: Reachability

    private init() {
        do {
            reachability = try Reachability()
            registerObserver()
            try reachability.startNotifier()

        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: - Private - Register observer
private extension NetworkReachabilityManager {

    func registerObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged),
            name: .reachabilityChanged,
            object: reachability
        )
    }

}

// MARK: - Private - Network status changed
private extension NetworkReachabilityManager {

    @objc func networkStatusChanged(_ notification: Notification) {
        guard let reachability = notification.object as? Reachability else {
            return
        }

        switch reachability.connection {
        case .wifi:
            debugPrint("File: \(#file), Function: \(#function), line: \(#line) Reachable via WiFi")

        case .cellular:
            debugPrint("File: \(#file), Function: \(#function), line: \(#line) Reachable via Cellular")

        case .unavailable:
            debugPrint("File: \(#file), Function: \(#function), line: \(#line) Network not reachable")
        }
    }
}

// MARK: - Network status checkers
extension NetworkReachabilityManager {

    func isReachable(completion: @escaping () -> Void) {
        if reachability.connection != .unavailable {
            completion()
        }
    }

    func isUnreachable(completion: @escaping () -> Void) {
        if reachability.connection == .unavailable {
            completion()
        }
    }

    func isReachableViaWWANCellular(completion: @escaping () -> Void) {
        if reachability.connection == .cellular {
            completion()
        }
    }

    func isReachableViaWiFi(completion: @escaping () -> Void) {
        if reachability.connection == .wifi {
            completion()
        }
    }

    func whenReachable(completionHandler: @escaping (_ networkReachable: Reachability) -> Void) {
        reachability.whenReachable = completionHandler
    }

    func whenUnreachable(completionHandler: @escaping (_ networkReachable: Reachability) -> Void) {
        reachability.whenUnreachable = completionHandler
    }

}
