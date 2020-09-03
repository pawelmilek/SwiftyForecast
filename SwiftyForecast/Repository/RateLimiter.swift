import Foundation

struct RateLimiter {
  static func canFetch(interval: TimeInterval) -> Bool {
    return false
  }
}
