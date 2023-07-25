import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var placeholderView = AppPlaceholderView(image: UIImage.emptyStatistic, text: "Анализировать пока нечего")
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        setupNavigationBar()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(placeholderView)
    }
    
    private func setupNavigationBar() {
        title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Setting Constraints

extension StatisticViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

