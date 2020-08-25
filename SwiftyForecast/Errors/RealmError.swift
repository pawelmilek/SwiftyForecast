enum RealmError: ErrorHandleable {
  case initializationFailed
  case transactionFailed(description: String)
  case fetchFailed
  case unknown
}

// MARK: - ErrorHandleable protocol
extension RealmError {
  
  var description: String {
    switch self {
    case .initializationFailed:
      return "Realm initialization failed."
      
    case .transactionFailed(let description):
      return "Realm transaction \(description) failed."
      
    case .fetchFailed:
      return "Could not fetch from Realm."
      
    case .unknown:
      return "Realm unknown error."
    }
  }
  
}
