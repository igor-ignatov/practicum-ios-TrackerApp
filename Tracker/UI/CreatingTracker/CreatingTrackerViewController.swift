import UIKit

protocol CreatingTrackerDelegate: AnyObject {
    func didSelectTrackerType(_ type: TrackerType)
}

final class CreatingTrackerViewController: UIViewController {
    
    // MARK: - Delegate
    
    private weak var delegate: CreatingTrackerDelegate?
    
    // MARK: - UI
    
    private lazy var titleLabel = AppTitleLabel(
        title: NSLocalizedString(
            "creatingTracker.title",
            comment: "Screen title"
        )
    )
    
    private lazy var habitButton: AppButton = {
        let button = AppButton(
            title: NSLocalizedString(
                "creatingTracker.habitButton",
                comment: "Button text"
            )
        )
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularEventsButton: AppButton = {
        let button = AppButton(
            title: NSLocalizedString(
                "creatingTracker.irregularEventButton",
                comment: "Button text"
            )
        )
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [habitButton, irregularEventsButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Life Cycle
    
    init(delegate: CreatingTrackerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
    }
    
    // MARK: - Actions
    
    @objc
    private func habitButtonTapped() {
        dismiss(animated: true)
        delegate?.didSelectTrackerType(.habit)
    }
    
    @objc
    private func irregularEventsButtonTapped() {
        dismiss(animated: true)
        delegate?.didSelectTrackerType(.irregularEvent)
    }
}

// MARK: - Setting Constraints

extension CreatingTrackerViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

