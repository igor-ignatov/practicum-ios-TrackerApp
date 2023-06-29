import Foundation

struct Tracker: Identifiable, Hashable {
    let id: UUID
    let label: String
    let emoji: String
    let color: TrackerColor
    let schedule: Set<WeekDay>?
    var isCompleted: Bool
    var completedCount: Int
}

extension Tracker {
    static var mockCatCamera: Self {
        .init(id: UUID(),
              label: "Кошка заслонила камеру на созвоне",
              emoji: "😻",
              color: .lightOrange,
              schedule: nil,
              isCompleted: false,
              completedCount: 10)
    }
    
    static var mockGrandma: Self {
        .init(id: UUID(),
              label: "Бабушка прислала открытку в вотсапе",
              emoji: "🌺",
              color: .red,
              schedule: nil,
              isCompleted: false,
              completedCount: 125)
    }
    
    static var mockDating: Self {
        .init(id: UUID(),
              label: "Свидания в апреле",
              emoji: "❤️",
              color: .paleBlue,
              schedule: .mockOnWeekends,
              isCompleted: false,
              completedCount: 0)
    }
    
    static var mockPlants: Self {
        .init(id: UUID(),
              label: "Поливая растения",
              emoji: "❤️",
              color: .green,
              schedule: .mockEveryDay,
              isCompleted: false,
              completedCount: 120)
    }
}
