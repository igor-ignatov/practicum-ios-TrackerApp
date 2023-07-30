import UIKit

enum SettingsCollectionViewSection {
    case emoji([String])
    case color([UIColor])
    
    var title: String {
        switch self {
        case .emoji:
            return NSLocalizedString(
                "newTracker.emojiTitle",
                comment: "Emoji title"
            )
        case .color:
            return NSLocalizedString(
                "newTracker.colorTitle",
                comment: "Color title"
            )
        }
    }
}
