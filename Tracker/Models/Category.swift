import Foundation

struct Category: Equatable {
    let id: UUID
    let name: String
    let trackers: [Tracker]
}
