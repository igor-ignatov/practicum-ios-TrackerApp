import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var placeholderView = AppPlaceholderView(
        image: UIImage.emptyList,
        text: NSLocalizedString(
            "trackers.emptyPlaceholderView",
            comment: "Placeholder text"
        )
    )
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale.current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
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
        let placeholderText = NSLocalizedString(
            "trackers.searchTextFieldPlaceholder",
            comment: "Placeholder text"
        )
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = placeholderText
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            NSLocalizedString(
                "trackers.filtersButton",
                comment: "Filter button text"
            ),
            for: .normal
        )
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.tintColor = .white
        button.backgroundColor = .appBlue
        button.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Data Source
    
    private lazy var trackerStore: TrackerStoreProtocol = TrackerStore(delegate: self)
    
    private lazy var recordStore: RecordStoreProtocol = RecordStore()
    
    // MARK: - Properties
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.shared.report(event: .open, screen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.shared.report(event: .close, screen: .main)
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(placeholderView)
        view.addSubview(collectionView)
        view.addSubview(filtersButton)
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
    
    private func makeContextMenu(by indexPath: IndexPath) -> UIMenu? {
        guard
            let tracker = trackerStore.object(at: indexPath),
            let category = trackerStore.category(at: indexPath)
        else { return nil }
        let pinTitle = NSLocalizedString("trackers.pinButton", comment: "Pin tracker")
        let unpinTitle = NSLocalizedString("trackers.unpinButton", comment: "Unpin tracker")
        
        let pinAction = UIAction(title: tracker.isPinned ? unpinTitle : pinTitle) { [weak self] _ in
            self?.trackerStore.pinTrackerToogle(at: indexPath)
        }
        
        let editAction = UIAction(title: NSLocalizedString("trackers.editButton", comment: "Edit tracker")) { [weak self] _ in
            guard let self else { return }
            let trackerDetailsViewController = TrackerDetailsViewController(tracker: tracker, category: category, delegate: self)
            self.present(trackerDetailsViewController, animated: true)
            AnalyticsService.shared.report(event: .click, screen: .main, item: .edit)
        }
        
        let deleteAction = UIAction(
            title: NSLocalizedString("trackers.deleteButton", comment: "Delete tracker"),
            attributes: .destructive
        ) { [weak self] _ in
            let alert = AlertFactory.shared.makeAlertConfirmingDeletion { [weak self] in
                self?.trackerStore.deleteTracker(at: indexPath)
            }
            self?.present(alert, animated: true)
            AnalyticsService.shared.report(event: .click, screen: .main, item: .delete)
        }
        
        return UIMenu(children: [pinAction, editAction, deleteAction])
    }
    
    // MARK: - Setup NavBar
    
    private func setupNavigationBar() {
        title = NSLocalizedString(
            "trackers.title",
            comment: "Screen title"
        )
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
    
    // MARK: - Actions
    
    @objc
    private func addButtonTapped() {
        let creatingTrackerViewController = CreatingTrackerViewController(delegate: self)
        present(creatingTrackerViewController, animated: true)
        AnalyticsService.shared.report(event: .click, screen: .main, item: .addTracker)
    }
    
    @objc
    private func dateChanged() {
        currentDate = Calendar.current.startOfDay(for: datePicker.date)
        applyFilter()
        isEmptyCategories()
        collectionView.reloadData()
    }
    
    @objc
    private func filtersButtonTapped() {
        let filtersViewController = FiltersViewController()
        present(filtersViewController, animated: true)
        AnalyticsService.shared.report(event: .click, screen: .main, item: .filter)
    }
}

// MARK: - CreatingTrackerDelegate

extension TrackersViewController: CreatingTrackerDelegate {
    func didSelectTrackerType(_ type: TrackerType) {
        let newTrackerViewController = TrackerDetailsViewController(trackerType: type, delegate: self)
        present(newTrackerViewController, animated: true)
    }
}

// MARK: - TrackerDetailsDelegate

extension TrackersViewController: TrackerDetailsDelegate {
    func didCreateNewTracker(_ tracker: Tracker, to category: Category) {
        dismiss(animated: true)
        trackerStore.addTracker(tracker, to: category)
        collectionView.reloadData()
    }
    
    func didUpdateTracker(_ tracker: Tracker, to category: Category?) {
        dismiss(animated: true)
        trackerStore.updateTracker(tracker, to: category)
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
            guard let indexPaths = trackerStore.getIndexPathsCompletedTracker(by: id) else {
                collectionView.reloadItems(at: [indexPath])
                return
            }
            collectionView.reloadItems(at: indexPaths)
            AnalyticsService.shared.report(event: .click, screen: .main, item: .track)
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        if let record = recordStore.fetchRecord(by: id, and: currentDate) {
            recordStore.delete(record)
            guard let indexPaths = trackerStore.getIndexPathsCompletedTracker(by: id) else {
                collectionView.reloadItems(at: [indexPath])
                return
            }
            collectionView.reloadItems(at: indexPaths)
            AnalyticsService.shared.report(event: .click, screen: .main, item: .track)
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
        return trackerStore.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerStore.numberOfRowsInSection(section)
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { suggestedActions in
            self.makeContextMenu(by: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
            let indexPath = configuration.identifier as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        else { return nil }
        return UITargetedPreview(view: cell.previewView)
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
            let indexPath = configuration.identifier as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        else { return nil }
        return UITargetedPreview(view: cell.previewView)
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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

