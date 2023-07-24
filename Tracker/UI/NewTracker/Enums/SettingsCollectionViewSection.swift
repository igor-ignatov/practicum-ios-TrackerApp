import UIKit

enum SettingsCollectionViewSection {
    case emoji([String])
    case color([UIColor])
    
    var title: String {
        switch self {
        case .emoji:
            return "Emoji"
        case .color:
            return "Цвет"
        }
    }
}
