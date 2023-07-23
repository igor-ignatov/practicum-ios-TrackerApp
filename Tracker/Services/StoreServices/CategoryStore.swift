import Foundation
import UIKit
import CoreData

final class CategoryStore: NSObject {
    private let dataStore: DataStore
    private let context: NSManagedObjectContext
    
    // ???
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
    private weak var delegate: StoreDelegate?
    
    // MARK: - FRC
    
    private lazy var fetchedResultController: NSFetchedResultsController<CategoryManagedObject> = {
        let request = CategoryManagedObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()

    // MARK: - Init
    
    init(dataStore: DataStore, delegate: StoreDelegate) {
        self.dataStore = dataStore
        self.context = dataStore.managedObjectContext
        self.delegate = delegate
    }
    
    convenience init(delegate: StoreDelegate) {
        self.init(dataStore: DataStore.shared, delegate: delegate)
    }
    
    // MARK: - Convert
    
    private func convert(managedObject: CategoryManagedObject) -> Category? {
        guard
            let id = managedObject.id,
            let name = managedObject.name,
            let trackerManagedObjects = managedObject.trackers?.array as? [TrackerManagedObject]
        else { return nil }
        let trackers: [Tracker] = trackerManagedObjects.compactMap({ convert(managedObject: $0) })
        return Category(
            id: id,
            name: name,
            trackers: trackers
        )
    }
    
    private func convert(managedObject: TrackerManagedObject) -> Tracker? {
        guard
            let id = managedObject.id,
            let name = managedObject.name,
            let emoji = managedObject.emoji,
            let hexColor = managedObject.hexColor,
            let scheduleString = managedObject.schedule
        else { return nil }
        return Tracker(
            id: id,
            name: name,
            color: ColorMarshall.shared.decode(hexColor: hexColor),
            emoji: emoji,
            schedule: WeekDayMarshall.shared.decode(weekDays: scheduleString)
        )
    }
}

extension CategoryStore {
    var isEmpty: Bool {
        fetchedResultController.fetchedObjects?.isEmpty ?? true
    }
    
    var numberOfRowsInSection: Int {
        fetchedResultController.fetchedObjects?.count ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Category? {
        let categoryManagedObject = fetchedResultController.object(at: indexPath)
        return convert(managedObject: categoryManagedObject)
    }
    
    func add(_ category: Category) {
        try? dataStore.performSync { context in
            Result {
                let categoryManagedObject = CategoryManagedObject(context: context)
                categoryManagedObject.id = category.id
                categoryManagedObject.name = category.name
                categoryManagedObject.createdAt = Date()
                categoryManagedObject.trackers = NSOrderedSet()
                try context.save()
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension CategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
