import Foundation
import CoreData

class CoreDataStackHelper {
  static let shared = CoreDataStackHelper()
  private let stack: CoreDataStack
  
  private init() {
    self.stack = CoreDataStack(modelName: "SwiftyForecast")
  }
  
  var managedContext: NSManagedObjectContext {
    return stack.managedContext
  }
  
  func saveContext() {
    stack.saveContext()
  }
}
