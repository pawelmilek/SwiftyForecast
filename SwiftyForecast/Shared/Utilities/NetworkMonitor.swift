import Foundation
import Network

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
            debugPrint(path)
            self?.hasNetworkConnection = path.status == .satisfied
        }
    }

    func start() {
        monitor.start(queue: DispatchQueue.global(qos: .userInteractive))
    }
}
