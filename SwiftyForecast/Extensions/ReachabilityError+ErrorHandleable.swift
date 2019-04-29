import Reachability

extension ReachabilityError: ErrorHandleable {
  
  public var description: String {
    switch self {
    case .FailedToCreateWithAddress(let cockaddrIn):
      return "Failed to create with address \(cockaddrIn)."
      
    case .FailedToCreateWithHostname(let hostname):
      return "Failed to create with hostname \(hostname)."
      
    case .UnableToSetCallback:
      return "Unable to set callback."
      
    case .UnableToSetDispatchQueue:
      return "Unable to set Dispatch Queue."
      
    case .UnableToGetInitialFlags:
      return "Unable to get initial flags."
    }
  }
  
}
