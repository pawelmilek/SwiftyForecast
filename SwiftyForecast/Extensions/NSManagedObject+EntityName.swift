import CoreData

extension NSManagedObject {
  
  static var entityName: String {
    return "\(self)"
  }
  
}

extension NSManagedObject {
  
  convenience init(managedObjectContext: NSManagedObjectContext) {
    let entityName = type(of: self).entityName
    let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
    self.init(entity: entity, insertInto: managedObjectContext)
  }
  
}
