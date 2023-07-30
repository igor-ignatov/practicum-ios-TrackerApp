import Foundation

enum WeekDay: Int, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var title: String {
        switch self {
        case .monday:
            return NSLocalizedString(
                "weekday.monday",
                comment: "Monday"
            )
        case .tuesday:
            return NSLocalizedString(
                "weekday.tuesday",
                comment: "Tuesday"
            )
        case .wednesday:
            return NSLocalizedString(
                "weekday.wednesday",
                comment: "Wednesday"
            )
        case .thursday:
            return NSLocalizedString(
                "weekday.thursday",
                comment: "Thursday"
            )
        case .friday:
            return NSLocalizedString(
                "weekday.friday",
                comment: "Friday"
            )
        case .saturday:
            return NSLocalizedString(
                "weekday.saturday",
                comment: "Saturday"
            )
        case .sunday:
            return NSLocalizedString(
                "weekday.sunday",
                comment: "Sunday"
            )
        }
    }
    
    var shortTitle: String {
        switch self {
        case .monday:
            return NSLocalizedString(
                "weekday.monday.short",
                comment: "Monday"
            )
        case .tuesday:
            return NSLocalizedString(
                "weekday.tuesday.short",
                comment: "Tuesday"
            )
        case .wednesday:
            return NSLocalizedString(
                "weekday.wednesday.short",
                comment: "Wednesday"
            )
        case .thursday:
            return NSLocalizedString(
                "weekday.thursday.short",
                comment: "Thursday"
            )
        case .friday:
            return NSLocalizedString(
                "weekday.friday.short",
                comment: "Friday"
            )
        case .saturday:
            return NSLocalizedString(
                "weekday.saturday.short",
                comment: "Saturday"
            )
        case .sunday:
            return NSLocalizedString(
                "weekday.sunday.short",
                comment: "Sunday"
            )
        }
    }
}
