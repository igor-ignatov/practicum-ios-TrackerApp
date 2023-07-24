import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var placeholderView = AppPlaceholderView(image: UIImage.emptyList, text: "Что будем отслеживать?")
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.calendar.firstWeekday = 2
        datePicker.tintColor = .appBlue
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .appWhite
        collectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.reuseIdentifier
        )
        collectionView.register(
            AppCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AppCollectionViewHeader.reuseIdentifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    // MARK: - Data Source
    
    private lazy var trackerStore = TrackerStore(delegate: self)
    private lazy var recordStore = RecordStore()
    
    private var currentDate = Calendar.current.startOfDay(for: Date())
    
    private var searchText: String = "" {
        didSet {
            applyFilter()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setupNavigationBar()
        setDelegates()
        applyFilter()
        isEmptyCategories()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(placeholderView)
        view.addSubview(collectionView)
    }
    
    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func isEmptyCategories() {
        trackerStore.isEmpty ? showPlaceholder() : showCollectionView()
    }
    
    private func showPlaceholder() {
        placeholderView.isHidden = false
        collectionView.isHidden = true
    }
    
    private func showCollectionView() {
        placeholderView.isHidden = true
        collectionView.isHidden = false
    }
    
    private func applyFilter() {
        trackerStore.filter(by: currentDate, and: searchText)
    }
    
    // MARK: - Setup NavBar
    
    private func setupNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .appBlack
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = setupLeftBarButtonItem()
        navigationItem.rightBarButtonItem = setupRightBarButtonItem()
    }
    
    private func setupLeftBarButtonItem() -> UIBarButtonItem {
        UIBarButtonItem(
            image: UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)
            ),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
    }
    
    private func setupRightBarButtonItem() -> UIBarButtonItem {
        UIBarButtonItem(customView: datePicker)
    }
    
    @objc
    private func addButtonTapped() {
        let creatingTrackerViewController = CreatingTrackerViewController(delegate: self)
        present(creatingTrackerViewController, animated: true)
    }
    
    @objc
    private func dateChanged() {
        currentDate = Calendar.current.startOfDay(for: datePicker.date)
        applyFilter()
        isEmptyCategories()
        collectionView.reloadData()
    }
}

// MARK: - CreatingTrackerDelegate

extension TrackersViewController: CreatingTrackerDelegate {
    func didSelectTrackerType(_ type: TrackerType) {
        let newTrackerViewController = NewTrackerViewController(with: type, delegate: self)
        present(newTrackerViewController, animated: true)
    }
}

// MARK: - NewTrackerDelegate

extension TrackersViewController: NewTrackerDelegate {
    func didCreateNewTracker(_ tracker: Tracker, to category: Category) {
        dismiss(animated: true)
        trackerStore.add(tracker, to: category)
        collectionView.reloadData()
    }
}

// MARK: - StoreDelegate

extension TrackersViewController: StoreDelegate {
    func didUpdate() {
        isEmptyCategories()
        collectionView.reloadData()
    }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        if currentDate < Date() {
            let record = Record(trackerId: id, executionDate: currentDate)
            recordStore.add(record, to: id)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        if let record = recordStore.fetchRecord(by: id, and: currentDate) {
            recordStore.delete(record)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        searchBar.text = ""
        searchBar.endEditing(true)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStore.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let currentTracker = trackerStore.object(at: indexPath),
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerCell
        else {
            return UICollectionViewCell()
        }
        
        let isCompletedToday = recordStore.isTrackerCompletedToday(by: currentTracker.id, and: currentDate)
        let completedDays = recordStore.completedTrackers(by: currentTracker.id)
        
        cell.delegate = self
        cell.configure(
            with: currentTracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            indexPath: indexPath
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            let header = trackerStore.header(at: indexPath),
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: AppCollectionViewHeader.reuseIdentifier,
                for: indexPath
            ) as? AppCollectionViewHeader
        else {
            return UICollectionReusableView()
        }
        view.configure(with: header)
        return view
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 32 - 8) / 2, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 50)
    }
}

// MARK: - Setting Constraints

extension TrackersViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

