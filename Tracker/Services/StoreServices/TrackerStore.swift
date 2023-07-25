import Foundation
import CoreData

protocol TrackerStoreProtocol {
    var isEmpty: Bool { get }
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func add(_ tracker: Tracker, to category: Category)
    func object(at indexPath: IndexPath) -> Tracker?
    func header(at indexPath: IndexPath) -> String?
    func filter(by date: Date, and searchText: String)
}

final class TrackerStore: NSObject {
    
    // MARK: - Delegate
    
    private weak var delegate: StoreDelegate?
    
    // MARK: - Properties
    
    private let dataStore: DataStore
    
    private let context: NSManagedObjectContext

    // MARK: - FRC
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerManagedObject> = {
        let request = TrackerManagedObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "category.name", ascending: true)]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "category.name",
            cacheName: nil
        )
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()
    
    // MARK: - Init
    
    init(dataStore: DataStore, delegate: StoreDelegate?) {
        self.dataStore = dataStore
        self.context = dataStore.managedObjectContext
        self.delegate = delegate
        super.init()
    }
    
    convenience init(delegate: StoreDelegate? = nil) {
        self.init(dataStore: DataStore.shared, delegate: delegate)
    }
    
    // MARK: - Convert
    
    private func convert(tracker: Tracker) -> TrackerManagedObject {
        let trackerManagedObject = TrackerManagedObject(context: context)
        trackerManagedObject.id = tracker.id
        trackerManagedObject.name = tracker.name
        trackerManagedObject.emoji = tracker.emoji
        trackerManagedObject.hexColor = ColorMarshall.shared.encode(color: tracker.color)
        trackerManagedObject.schedule = WeekDayMarshall.shared.encode(weekDays: tracker.schedule)
        return trackerManagedObject
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

extension TrackerStore: TrackerStoreProtocol {
    
    var isEmpty: Bool {
        fetchedResultController.sections?.isEmpty ?? true
    }
    
    var numberOfSections: Int {
        fetchedResultController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func add(_ tracker: Tracker, to category: Category) {
        try? dataStore.performSync { context in
            Result {
                let request = CategoryManagedObject.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
                guard
                    let categoryManagedObject = try? context.fetch(request).first
                else { return }
                let trackerManagedObject = convert(tracker: tracker)
                categoryManagedObject.addToTrackers(trackerManagedObject)
                try context.save()
            }
        }
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerManagedObject = fetchedResultController.object(at: indexPath)
        return convert(managedObject: trackerManagedObject)
    }
    
    func header(at indexPath: IndexPath) -> String? {
        fetchedResultController.sections?[indexPath.section].name
    }
    
    func filter(by date: Date, and searchText: String) {
        var predicates: [NSPredicate] = []
        let weekDay = Calendar.current.component(.weekday, from: date)
        let weekDayIndex = String(weekDay > 1 ? weekDay - 2 : weekDay + 5)
        predicates.append(
            NSPredicate(format: "%K CONTAINS[cd] %@", "schedule", weekDayIndex)
        )
        if !searchText.isEmpty {
            predicates.append(
                NSPredicate(format: "%K CONTAINS[cd] %@", "name", searchText)
            )
        }
        fetchedResultController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        try? fetchedResultController.performFetch()
        delegate?.didUpdate()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
