import Foundation

enum SettingsTableViewSection: Int, CaseIterable {
    case category
    case schedule
    
    var title: String {
        switch self {
        case .category:
            return NSLocalizedString(
                "newTracker.categoryButton",
                comment: "Category title"
            )
        case .schedule:
            return NSLocalizedString(
                "newTracker.scheduleButton",
                comment: "Category title"
            )
        }
    }
}
