import Foundation
import CoreData

extension NSPersistentContainer {
    static func create(for model: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores {
            if let error = $1 {
                assertionFailure("Error loading the persistent container: \(error)")
            }
        }
        return container
    }
}

