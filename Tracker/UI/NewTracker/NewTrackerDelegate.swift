import UIKit

protocol NewTrackerDelegate: AnyObject {
    func didCreateNewTracker(_ tracker: Tracker, to category: Category)
}
