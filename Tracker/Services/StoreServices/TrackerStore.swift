import Foundation
import CoreData

protocol TrackerStoreProtocol {
    var isEmpty: Bool { get }
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func addTracker(_ tracker: Tracker, to category: Category)
    func updateTracker(_ tracker: Tracker, to category: Category?)
    func deleteTracker(at indexPath: IndexPath)
    func object(at indexPath: IndexPath) -> Tracker?
    func header(at indexPath: IndexPath) -> String?
    func category(at indexPath: IndexPath) -> Category?
    func filter(by date: Date, and searchText: String)
    func pinTrackerToogle(at indexPath: IndexPath)
    func getIndexPathsCompletedTracker(by id: UUID) -> [IndexPath]?
}

final class TrackerStore: NSObject {
    
    // MARK: - Delegate
    
    private weak var delegate: StoreDelegate?
    
    // MARK: - Properties
    
    private let dataStore: DataStore
    
    private let context: NSManagedObjectContext
    
    private var pinnedTrackers: [Tracker]? {
        guard
            let pinnedTrackers = pinnedTrackersFetchedResultController.fetchedObjects
        else { return nil }
        return pinnedTrackers.compactMap{ convert(managedObject: $0) }
    }

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
    
    private lazy var pinnedTrackersFetchedResultController: NSFetchedResultsController<TrackerManagedObject> = {
        let request = TrackerManagedObject.fetchRequest()
        request.predicate = NSPredicate(format: "isPinned == YES")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
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
        trackerManagedObject.isPinned = tracker.isPinned
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
            schedule: WeekDayMarshall.shared.decode(weekDays: scheduleString),
            isPinned: managedObject.isPinned
        )
    }
    
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
    
    private func fetchTrackerManagedObject(by id: UUID) -> TrackerManagedObject? {
        let request = TrackerManagedObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let trackerManagedObject = try? context.fetch(request).first else { return nil }
        return trackerManagedObject
    }
}

// MARK: - TrackerStoreProtocol

extension TrackerStore: TrackerStoreProtocol {
    
    var isEmpty: Bool {
        fetchedResultController.sections?.isEmpty ?? true
    }
    
    var pinnedTrackersIsEmpty: Bool {
        pinnedTrackers?.isEmpty ?? true
    }
    
    var numberOfSections: Int {
        if !pinnedTrackersIsEmpty {
            return (fetchedResultController.sections?.count ?? 0) + 1
        }
        return fetchedResultController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if !pinnedTrackersIsEmpty {
            if section == 0 {
                return pinnedTrackersFetchedResultController.fetchedObjects?.count ?? 0
            } else {
                return fetchedResultController.sections?[section - 1].numberOfObjects ?? 0
            }
        }
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        if !pinnedTrackersIsEmpty {
            if indexPath.section == 0 {
                return convert(managedObject: pinnedTrackersFetchedResultController.object(at: indexPath))
            } else {
                let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
                let trackerManagedObject = fetchedResultController.object(at: newIndexPath)
                return convert(managedObject: trackerManagedObject)
            }
        }
        let trackerManagedObject = fetchedResultController.object(at: indexPath)
        return convert(managedObject: trackerManagedObject)
    }
    
    func object(at indexPath: IndexPath) -> TrackerManagedObject? {
        if !pinnedTrackersIsEmpty {
            if indexPath.section == 0 {
                return pinnedTrackersFetchedResultController.object(at: indexPath)
            } else {
                let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
                let trackerManagedObject = fetchedResultController.object(at: newIndexPath)
                return trackerManagedObject
            }
        }
        let trackerManagedObject = fetchedResultController.object(at: indexPath)
        return trackerManagedObject
    }
    
    func header(at indexPath: IndexPath) -> String? {
        if !pinnedTrackersIsEmpty {
            if indexPath.section == 0 {
                return NSLocalizedString("trackers.pinnedTitle", comment: "Pinned trackers title")
            } else {
                return fetchedResultController.sections?[indexPath.section - 1].name
            }
        }
        return fetchedResultController.sections?[indexPath.section].name
    }
    
    func category(at indexPath: IndexPath) -> Category? {
        guard
            let trackerManagedObject: TrackerManagedObject = object(at: indexPath),
            let categoryManagedObject = trackerManagedObject.category
        else { return nil }
        return convert(managedObject: categoryManagedObject)
    }
    
    func addTracker(_ tracker: Tracker, to category: Category) {
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
    
    func updateTracker(_ tracker: Tracker, to category: Category?) {
        try? dataStore.performSync { context in
            Result {
                guard
                    let trackerManagedObject = fetchedResultController.fetchedObjects?.first(where: {
                        $0.id == tracker.id
                    })
                else { return }
                trackerManagedObject.name = tracker.name
                trackerManagedObject.emoji = tracker.emoji
                trackerManagedObject.hexColor = ColorMarshall.shared.encode(color: tracker.color)
                trackerManagedObject.schedule = WeekDayMarshall.shared.encode(weekDays: tracker.schedule)
                trackerManagedObject.isPinned = tracker.isPinned
                if let category {
                    let request = CategoryManagedObject.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
                    if let categoryManagedObject = try? context.fetch(request).first {
                        trackerManagedObject.category = categoryManagedObject
                    }
                }
                try context.save()
            }
        }
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        try? dataStore.performSync{ context in
            Result {
                if !pinnedTrackersIsEmpty {
                    if indexPath.section == 0 {
                        context.delete(pinnedTrackersFetchedResultController.object(at: indexPath))
                    } else {
                        let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
                        let trackerManagedObject = fetchedResultController.object(at: newIndexPath)
                        context.delete(trackerManagedObject)
                    }
                } else {
                    let trackerManagedObject = fetchedResultController.object(at: indexPath)
                    context.delete(trackerManagedObject)
                }
                try context.save()
            }
        }
    }
    
    func pinTrackerToogle(at indexPath: IndexPath) {
        try? dataStore.performSync { context in
            Result {
                if !pinnedTrackersIsEmpty {
                    if indexPath.section == 0 {
                        let pinnedTrackerManagedObject = pinnedTrackersFetchedResultController.object(at: indexPath)
                        pinnedTrackerManagedObject.isPinned.toggle()
                    } else {
                        let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
                        let trackerManagedObject = fetchedResultController.object(at: newIndexPath)
                        trackerManagedObject.isPinned.toggle()
                    }
                } else {
                    let trackerManagedObject = fetchedResultController.object(at: indexPath)
                    trackerManagedObject.isPinned.toggle()
                }
                try context.save()
            }
        }
    }
    
    func filter(by date: Date, and searchText: String) {
        var predicates: [NSPredicate] = []
        let weekDay = Calendar.current.component(.weekday, from: date)
        let weekDayIndex = String(weekDay > 1 ? weekDay - 2 : weekDay + 5)
        predicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", "schedule", weekDayIndex))
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", "name", searchText))
        }
        fetchedResultController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        try? fetchedResultController.performFetch()
        delegate?.didUpdate()
    }
    
    func getIndexPathsCompletedTracker(by id: UUID) -> [IndexPath]? {
        guard let trackerManagedObject = fetchTrackerManagedObject(by: id) else { return nil }
        var indexPaths: [IndexPath] = []
        if !pinnedTrackersIsEmpty {
            if let pinnedTrackerIndexPath = pinnedTrackersFetchedResultController.indexPath(forObject: trackerManagedObject) {
                indexPaths.append(pinnedTrackerIndexPath)
            }
            if let trackerIndexPath = fetchedResultController.indexPath(forObject: trackerManagedObject) {
                let newIndexPath = IndexPath(item: trackerIndexPath.item, section: trackerIndexPath.section + 1)
                indexPaths.append(newIndexPath)
            }
        } else {
            if let trackerIndexPath = fetchedResultController.indexPath(forObject: trackerManagedObject) {
                indexPaths.append(trackerIndexPath)
            }
        }
        return indexPaths
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
