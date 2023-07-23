import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension UICollectionReusableView: Reusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
