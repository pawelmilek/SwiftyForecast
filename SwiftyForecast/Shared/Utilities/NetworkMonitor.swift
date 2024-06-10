import Foundation
import Combine
import Network
//
//protocol NetworkObserver: AnyObject {
//    var hasNetworkConnection: Bool { get set }
//    func start()
//}
//
//extension NWPathMonitor: NetworkObserver {
//    func start() {
//        self.start(queue: DispatchQueue.global(qos: .userInteractive))
//    }
//}

extension NWPathMonitor: Sendable { }

final class NetworkMonitor: ObservableObject {
    @Published var hasNetworkConnection = true
    private let monitor: NWPathMonitor

    convenience init() {
        self.init(monitor: .init())
    }

    init(monitor: NWPathMonitor) {
        self.monitor = monitor
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            setNetworkConnectionState(path.status == .satisfied)
        }
    }

    private func setNetworkConnectionState(_ value: Bool) {
        hasNetworkConnection = value
    }

    func start() {
        monitor.start(queue: DispatchQueue.global(qos: .userInteractive))
    }


}
