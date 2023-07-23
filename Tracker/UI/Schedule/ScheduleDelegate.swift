import Foundation

protocol ScheduleDelegate: AnyObject {
    func didSelectDays(_ days: Set<WeekDay>)
}
