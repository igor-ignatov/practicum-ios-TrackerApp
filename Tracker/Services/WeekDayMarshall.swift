import Foundation

final class WeekDayMarshall {
    
    static let shared = WeekDayMarshall()
    
    private init() {}
    
    func encode(weekDays: [WeekDay]) -> String {
        weekDays
            .map({ "\($0.rawValue)" })
            .joined(separator: ", ")
    }
    
    func decode(weekDays: String) -> [WeekDay] {
        weekDays
            .components(separatedBy: ", ")
            .compactMap({ Int($0) })
            .compactMap({ WeekDay(rawValue: $0) })
    }
}
