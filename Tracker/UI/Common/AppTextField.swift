import UIKit

final class AppTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setupView(with: placeholder)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(with placeholder: String) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.height))
        leftViewMode = .always
        clearButtonMode = .always
        layer.cornerRadius = 10
        backgroundColor = .appBackground
        self.placeholder = placeholder
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Setting Constraints

extension AppTextField {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}
