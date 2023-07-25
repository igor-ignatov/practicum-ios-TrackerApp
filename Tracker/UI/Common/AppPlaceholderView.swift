import UIKit

final class AppPlaceholderView: UIView {
    
    // MARK: - UI
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textColor = .appBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyImageView, emptyLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Life Cycle
    
    init(image: UIImage?, text: String) {
        super.init(frame: .zero)
        setupView(with: image, and: text)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emptyLabel.setLineHeight(lineHeight: 1.18)
        emptyLabel.textAlignment = .center
    }
    
    private func setupView(with image: UIImage?, and text: String) {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyStackView)
        emptyImageView.image = image
        emptyLabel.text = text
    }
}

// MARK: - Setting Constraints

extension AppPlaceholderView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            emptyStackView.topAnchor.constraint(equalTo: topAnchor),
            emptyStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            
            emptyLabel.leadingAnchor.constraint(equalTo: emptyStackView.leadingAnchor, constant: 70),
            emptyLabel.trailingAnchor.constraint(equalTo: emptyStackView.trailingAnchor, constant: -70)
        ])
    }
}
