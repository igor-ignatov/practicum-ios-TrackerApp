import Foundation

enum SettingsTableViewSection: Int, CaseIterable {
    case category
    case schedule
    
    var title: String {
        switch self {
        case .category:
            return "Категория"
        case .schedule:
            return "Расписание"
        }
    }
}
