import UIKit

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell & Reusable>(cellType: Cell.Type) -> Cell {
        (dequeueReusableCell(withIdentifier: cellType.reuseIdentifier) as? Cell) ?? Cell()
    }

    func registerReusableCell<Cell: UITableViewCell & Reusable>(cellType: Cell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
}
