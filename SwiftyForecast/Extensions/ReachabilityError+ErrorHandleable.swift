import Reachability

extension ReachabilityError: ErrorHandleable {
  
  public var description: String {
    switch self {
    case .failedToCreateWithAddress(let cockAddressIn, _):
      return "Failed to create with address \(cockAddressIn)."
      
    case .failedToCreateWithHostname(let hostName, _):
      return "Failed to create with hostname \(hostName)."
      
    case .unableToSetCallback:
      return "Unable to set callback."
      
    case .unableToSetDispatchQueue:
      return "Unable to set Dispatch Queue."
      
    case .unableToGetFlags:
      return "Unable to get initial flags."
    }
  }
  
}
