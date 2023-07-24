import Foundation

protocol CategoryViewModelProtocol: AnyObject {
    var viewModelDidChange: ((CategoryViewModelProtocol) -> Void)? { get set }
    var isEmpty: Bool { get }
    var numberOfRowsInSection: Int { get }
    var selectedCategoryIndexPath: IndexPath? { get }
    func addCategory(_ category: Category)
    func object(at indexPath: IndexPath) -> Category?
    func cellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel?
    func didSelectRow(at indexPath: IndexPath)
}

protocol CategoryDelegate: AnyObject {
    func didSelectCategory(_ selectedCategory: Category, at indexPath: IndexPath?)
}

final class CategoryViewModel: CategoryViewModelProtocol {
    
    private weak var delegate: CategoryDelegate?
    
    private lazy var categoryStore: CategoryStoreProtocol = CategoryStore(delegate: self)
    
    var selectedCategoryIndexPath: IndexPath?
    
    var viewModelDidChange: ((CategoryViewModelProtocol) -> Void)?
    
    var isEmpty: Bool {
        categoryStore.isEmpty
    }
    
    var numberOfRowsInSection: Int {
        categoryStore.numberOfRowsInSection
    }
    
    init(delegate: CategoryDelegate, selectedCategoryIndexPath: IndexPath? = nil) {
        self.delegate = delegate
        self.selectedCategoryIndexPath = selectedCategoryIndexPath
    }
    
    func addCategory(_ category: Category) {
        categoryStore.add(category)
    }
    
    func object(at indexPath: IndexPath) -> Category? {
        categoryStore.object(at: indexPath)
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel? {
        guard let category = categoryStore.object(at: indexPath) else { return nil }
        return CategoryCellViewModel(category: category)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let category = categoryStore.object(at: indexPath) else { return }
        selectedCategoryIndexPath = indexPath
        delegate?.didSelectCategory(category, at: selectedCategoryIndexPath)
    }
}

// MARK: - StoreDelegate

extension CategoryViewModel: StoreDelegate {
    func didUpdate() {
        viewModelDidChange?(self)
    }
}



