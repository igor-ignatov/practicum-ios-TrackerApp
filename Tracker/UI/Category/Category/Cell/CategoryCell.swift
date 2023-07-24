import UIKit

final class CategoryCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.cornerRadius = 0
        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
    }
}
