import UIKit

final class AppButton: UIButton {
    
    // MARK: - Enums
    
    enum ButtonState {
        case enabled
        case disabled
    }
    
    enum ButtonStyle {
        case normal
        case cancel
    }
    
    // MARK: - Properties

    private var disabledBackgroundColor = UIColor.appGray
    private var enabledBackgroundColor = UIColor.appBlack {
        didSet {
            backgroundColor = enabledBackgroundColor
        }
    }

    private var style: ButtonStyle = .normal
    private var height: CGFloat = 60
    private var action: (() -> Void)?
    
    // MARK: - Init
    
    convenience init(
        title: String,
        style: ButtonStyle = .normal,
        height: CGFloat = 60,
        action: @escaping () -> Void
    ) {
        self.init(type: .system)
        self.style = style
        self.height = height
        self.action = action
        
        setTitle(title, for: .normal)
        setupButton()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    override var isEnabled: Bool {
        didSet {
            switch style {
            case .normal:
                backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
            case .cancel:
                layer.borderColor = isEnabled ? UIColor.appRed.cgColor : UIColor.appGray.cgColor
            }
        }
    }
    
    private func setupButton() {
        switch style {
        case .normal:
            backgroundColor = enabledBackgroundColor
            setTitleColor(.appWhite, for: .normal)
            setTitleColor(.appWhite, for: .disabled)
        case .cancel:
            backgroundColor = .clear
            layer.borderColor = UIColor.appRed.cgColor
            layer.borderWidth = 1
            setTitleColor(.appRed, for: .normal)
            setTitleColor(.appGray, for: .disabled)
        }
        
        layer.cornerRadius = 16
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Action
    
    @objc
    private func buttonTapped() {
        action?()
    }
}

// MARK: - Setting Constraints

extension AppButton {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
