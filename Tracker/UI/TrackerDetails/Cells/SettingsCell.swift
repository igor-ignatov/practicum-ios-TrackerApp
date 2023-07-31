import UIKit

final class SettingsCell: UITableViewCell {
    
    // MARK: - UI
    
    private lazy var settingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectedSettingsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .appGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var settingsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [settingTitleLabel, selectedSettingsLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var disclosureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = .appGray
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        backgroundColor = .appBackground
        
        contentView.addSubview(settingsStackView)
        contentView.addSubview(disclosureImage)
    }
    
    func configure(with title: String) {
        settingTitleLabel.text = title
    }
    
    func updateSelectedSettings(_ selectedSettings: String) {
        selectedSettingsLabel.text = selectedSettings
    }
}

// MARK: - Setting Constraints

extension SettingsCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            settingsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            settingsStackView.trailingAnchor.constraint(equalTo: disclosureImage.leadingAnchor, constant: -16),
            settingsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            disclosureImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            disclosureImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            disclosureImage.widthAnchor.constraint(equalToConstant: 24),
            disclosureImage.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
