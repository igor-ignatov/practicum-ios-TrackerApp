import Foundation
import CoreData

final class DataStore {
    static let shared = DataStore()
    
    private let model = "TrackerDataModel"
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer.create(for: model)
        context = container.viewContext
    }
    
    var managedObjectContext: NSManagedObjectContext {
        context
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
}
