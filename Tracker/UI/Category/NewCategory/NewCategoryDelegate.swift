import Foundation

protocol NewCategoryDelegate: AnyObject {
    func didCreateNewCategory(_ category: Category)
}
