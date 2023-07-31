import UIKit

final class StatsViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var placeholderView = AppPlaceholderView(
        image: UIImage.emptyStatistic,
        text: NSLocalizedString(
            "stats.emptyPlaceholderView",
            comment: "Placeholder text"
        )
    )
    
    private lazy var trackersCompletedCounter = StatsView()
    
    // MARK: - Data Source
    
    private lazy var recordStore: RecordStoreProtocol = RecordStore(delegate: self)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setupNavigationBar()
        fetchNumberOfAllRecords()
        isEmptyStats()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(placeholderView)
        view.addSubview(trackersCompletedCounter)
    }
    
    private func setupNavigationBar() {
        title = NSLocalizedString(
            "stats.title",
            comment: "Screen title"
        )
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func isEmptyStats() {
        recordStore.isEmpty ? showPlaceholder() : showCollectionView()
    }
    
    private func showPlaceholder() {
        placeholderView.isHidden = false
        trackersCompletedCounter.isHidden = true
    }
    
    private func showCollectionView() {
        placeholderView.isHidden = true
        trackersCompletedCounter.isHidden = false
    }
    
    private func fetchNumberOfAllRecords() {
        trackersCompletedCounter.configure(
            with: String.localizedStringWithFormat(
                NSLocalizedString("numberOfTrackers", comment: "Number of trackers"),
                recordStore.fetchNumberOfAllRecords()
            )
        )
    }
}

// MARK: - StoreDelegate

extension StatsViewController: StoreDelegate {
    func didUpdate() {
        fetchNumberOfAllRecords()
        isEmptyStats()
    }
}

// MARK: - Setting Constraints

extension StatsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            trackersCompletedCounter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackersCompletedCounter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCompletedCounter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

