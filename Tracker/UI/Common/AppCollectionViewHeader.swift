import UIKit

final class AppCollectionViewHeader: UICollectionReusableView {
    
    // MARK: - UI
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        addSubview(headerTitleLabel)
    }
    
    func configure(with title: String) {
        headerTitleLabel.text = title
    }
}

// MARK: - Setting Constraints

extension AppCollectionViewHeader {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            headerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
