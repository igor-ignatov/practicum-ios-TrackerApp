import Foundation

protocol WeekdayCellDelegate: AnyObject {
    func didSelectDay(_ day: WeekDay)
    func didDeselectDay(_ day: WeekDay)
}
