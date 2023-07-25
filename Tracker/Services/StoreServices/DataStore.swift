import Foundation
import CoreData

final class DataStore {
    
    static let shared = DataStore()
    
    // MARK: - Properties
    
    private let model = "TrackerDataModel"
    
    private let container: NSPersistentContainer
    
    private let context: NSManagedObjectContext
    
    var managedObjectContext: NSManagedObjectContext {
        context
    }
    
    // MARK: - Init
    
    private init() {
        container = NSPersistentContainer.create(for: model)
        context = container.viewContext
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
}
