import Foundation
import CoreData

protocol RecordStoreProtocol {
    func isTrackerCompletedToday(by trackerId: UUID, and currentDate: Date) -> Bool
    func completedTrackers(by trackerId: UUID) -> Int
    func fetchRecord(by trackerId: UUID, and currentDate: Date) -> Record?
    func add(_ record: Record, to trackerId: UUID)
    func delete(_ record: Record)
}

final class RecordStore: NSObject {
    
    // MARK: - Properties
    
    private let dataStore: DataStore
    
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
        self.context = dataStore.managedObjectContext
        super.init()
    }
    
    override convenience init() {
        self.init(dataStore: DataStore.shared)
    }
    
    // MARK: - Convert
    
    private func convert(record: Record) -> RecordManagedObject {
        let recordManagedObject = RecordManagedObject(context: context)
        recordManagedObject.trackerId = record.trackerId
        recordManagedObject.executionDate = record.executionDate
        return recordManagedObject
    }
    
    private func convert(managedObject: RecordManagedObject) -> Record? {
        guard
            let taskId = managedObject.trackerId,
            let executionDate = managedObject.executionDate
        else { return nil }
        return Record(
            trackerId: taskId,
            executionDate: executionDate
        )
    }
}

extension RecordStore: RecordStoreProtocol {
    
    func isTrackerCompletedToday(by trackerId: UUID, and currentDate: Date) -> Bool {
        fetchRecord(by: trackerId, and: currentDate) != nil
    }
    
    func completedTrackers(by trackerId: UUID) -> Int {
        let request = RecordManagedObject.fetchRequest()
        request.predicate = NSPredicate(format: "trackerId == %@", trackerId as CVarArg)
        guard
            let recordManagedObjects = try? context.fetch(request)
        else { return 0 }
        return recordManagedObjects.count
    }
    
    func fetchRecord(by trackerId: UUID, and currentDate: Date) -> Record? {
        let request = RecordManagedObject.fetchRequest()
        let datePredicate = NSPredicate(format: "executionDate == %@", currentDate as CVarArg)
        let trackerIdPredicate = NSPredicate(format: "trackerId == %@", trackerId as CVarArg)
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [datePredicate, trackerIdPredicate])
        guard
            let recordManagedObject = try? context.fetch(request).first
        else { return nil }
        return convert(managedObject: recordManagedObject)
    }
    
    func add(_ record: Record, to trackerId: UUID) {
        try? dataStore.performSync { context in
            Result {
                _ = convert(record: record)
                try context.save()
            }
        }
    }
    
    func delete(_ record: Record) {
        try? dataStore.performSync{ context in
            Result {
                let request = RecordManagedObject.fetchRequest()
                let datePredicate = NSPredicate(format: "executionDate == %@", record.executionDate as CVarArg)
                let trackerIdPredicate = NSPredicate(format: "trackerId == %@", record.trackerId as CVarArg)
                request.predicate = NSCompoundPredicate(type: .and, subpredicates: [datePredicate, trackerIdPredicate])
                guard
                    let recordManagedObject = try? context.fetch(request).first
                else { return }
                context.delete(recordManagedObject)
                try context.save()
            }
        }
    }
}

