import Reachability

extension ReachabilityError: ErrorHandleable {
  
  public var description: String {
    switch self {
    case .failedToCreateWithAddress(let cockaddrIn):
      return "Failed to create with address \(cockaddrIn)."
      
    case .failedToCreateWithHostname(let hostname):
      return "Failed to create with hostname \(hostname)."
      
    case .unableToSetCallback:
      return "Unable to set callback."
      
    case .unableToSetDispatchQueue:
      return "Unable to set Dispatch Queue."
      
    case .unableToGetFlags:
      return "Unable to get initial flags."
    }
  }
  
}
