import UIKit

protocol NewCategoryDelegate: AnyObject {
    func didCreateNewCategory(_ category: Category)
}

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Delegate
    
    private weak var delegate: NewCategoryDelegate?
    
    // MARK: - UI
    
    private lazy var titleLabel = AppTitleLabel(
        title: NSLocalizedString(
            "newCategory.title",
            comment: "Screen title"
        )
    )
    
    private lazy var textField = AppTextField(
        placeholder: NSLocalizedString(
            "newCategory.nameTextFieldPlaceholder",
            comment: "Placeholder text"
        )
    )
    
    private lazy var finishedButton: AppButton = {
        let button = AppButton(
            title: NSLocalizedString(
                "newCategory.doneButton",
                comment: "Button text"
            )
        )
        button.addTarget(self, action: #selector(finishedButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Life Cycle
    
    init(delegate: NewCategoryDelegate) {
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
        setDelegates()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(finishedButton)
        finishedButton.isEnabled = false
    }
    
    private func setDelegates() {
        textField.delegate = self
    }
    
    // MARK: - Actions
    
    @objc
    private func finishedButtonTapped() {
        guard let text = textField.text, text != "" else { return }
        let newCategory = Category(id: UUID(), name: text, trackers: [])
        delegate?.didCreateNewCategory(newCategory)
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        let symbols = text.filter { $0.isNumber || $0.isLetter || $0.isSymbol || $0.isPunctuation }.count
        finishedButton.isEnabled = symbols != 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - Setting Constraints

extension NewCategoryViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            finishedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            finishedButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            finishedButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

