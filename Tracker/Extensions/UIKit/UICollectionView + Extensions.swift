import UIKit

extension UICollectionView {
    func registerReusableCell<Cell: UICollectionViewCell & Reusable>(cellType: Cell.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell & Reusable>(cellType: Cell.Type, indexPath: IndexPath) -> Cell {
        (dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell) ?? Cell()
    }
    
    func registerSupplementaryView<View: UICollectionReusableView & Reusable>(view: View.Type, forSupplementaryViewOfKind kind: String) {
        register(view, forSupplementaryViewOfKind: kind, withReuseIdentifier: view.reuseIdentifier)
    }
    
    func dequeueSupplementaryView<View: UICollectionReusableView & Reusable>(view: View.Type, forSupplementaryViewOfKind kind: String, indexPath: IndexPath) -> View {
        (dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: view.reuseIdentifier, for: indexPath) as? View) ?? View()
    }
}
