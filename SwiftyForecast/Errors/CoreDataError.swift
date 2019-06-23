enum CoreDataError: ErrorHandleable {
  case entityNotFound
  case couldNotSave
  case couldNotFetch
  case notAssociatedWithManagedObjectContext(entityName: String)
}

// MARK: - ErrorHandleable protocol
extension CoreDataError {
  
  var description: String {
    switch self {
    case .entityNotFound:
      return "No Entity found. Check the Entity Name."
      
    case .couldNotSave:
      return "Could not save in managed contex."
      
    case .couldNotFetch:
      return "Could not fetch from managed contex."
      
    case .notAssociatedWithManagedObjectContext(let entityName):
      return "Provided \(entityName) managed object is not associated with a managed object context."
    }
  }
  
}
