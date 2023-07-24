import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var titleLabel = AppTitleLabel(title: "Категория")
    
    private lazy var placeholderView = AppPlaceholderView(image: UIImage.emptyList, text: "Привычки и события можно объединить по смыслу")
    
    private lazy var tableView: AppTableView = {
        let tableView = AppTableView(frame: .zero)
        tableView.bounces = false
        tableView.allowsMultipleSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .appGray
        tableView.registerReusableCell(cellType: CategoryCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addCategoryButton = AppButton(title: "Добавить категорию") { [weak self] in
        guard let self else { return }
        let newCategoryViewController = NewCategoryViewController(delegate: self)
        self.present(newCategoryViewController, animated: true)
    }
    
    // MARK: - Data Source
    
    private lazy var categoryStore = CategoryStore(delegate: self)
    
    private var selectedCategory: Category?
    
    weak var delegate: CategoryDelegate?
    
    // MARK: - Life Cycle
    
    init(selectedCategory: Category?) {
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setDelegates()
        isEmptyCategories()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(titleLabel)
        view.addSubview(placeholderView)
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
    }
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func isEmptyCategories() {
        categoryStore.isEmpty ? showPlaceholder() : showCollectionView()
    }
    
    private func showPlaceholder() {
        placeholderView.isHidden = false
        tableView.isHidden = true
    }
    
    private func showCollectionView() {
        placeholderView.isHidden = true
        tableView.isHidden = false
    }
}

// MARK: - NewCategoryDelegate

extension CategoryViewController: NewCategoryDelegate {
    func didCreateNewCategory(_ category: Category) {
        categoryStore.add(category)
        isEmptyCategories()
    }
}

// MARK: - StoreDelegate

extension CategoryViewController: StoreDelegate {
    func didUpdate() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryStore.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: CategoryCell.self)
        guard let category = categoryStore.object(at: indexPath) else { return cell }
        cell.prepareForReuse()
        cell.textLabel?.text = category.name
        cell.backgroundColor = .appBackground
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        guard
            let selectedCategory,
            selectedCategory == category
        else { return cell }
        cell.setSelected(true, animated: true)
        cell.accessoryType = .checkmark
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath),
            let category = categoryStore.object(at: indexPath)
        else { return }
        tableView.visibleCells.forEach {
            $0.setSelected(false, animated: true)
            $0.accessoryType = .none
        }
        cell.accessoryType = .checkmark
        delegate?.didSelectCategory(category)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: .greatestFiniteMagnitude
            )
        } else {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 16,
                bottom: 0,
                right: 16
            )
        }
    }
}

// MARK: - Setting Constraints

extension CategoryViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addCategoryButton.topAnchor, constant: -16),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

