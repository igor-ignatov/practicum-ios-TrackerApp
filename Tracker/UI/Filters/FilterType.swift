import Foundation

enum FilterType: Int, CaseIterable {
    case all
    case today
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .all:
            return NSLocalizedString(
                "filters.allButton",
                comment: "All trackers filter"
            )
        case .today:
            return NSLocalizedString(
                "filters.todayButton",
                comment: "Today's trackers filter"
            )
        case .completed:
            return NSLocalizedString(
                "filters.completedButton",
                comment: "Completed trackers filter"
            )
        case .uncompleted:
            return NSLocalizedString(
                "filters.uncompletedButton",
                comment: "Uncompleted trackers filter"
            )
        }
    }
}
