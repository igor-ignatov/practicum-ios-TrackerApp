import Foundation

protocol CategoryCellViewModelProtocol {
    var categoryName: String { get }
    init(category: Category)
}

final class CategoryCellViewModel: CategoryCellViewModelProtocol {
    
    private let category: Category
    
    var categoryName: String {
        category.name
    }
    
    init(category: Category) {
        self.category = category
    }
}


