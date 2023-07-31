import UIKit

final class AppTitleLabel: UILabel {
    
    // MARK: - Lify Cycle
    
    init(title: String) {
        super.init(frame: .zero)
        setupView(with: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupView(with title: String) {
        text = title
        font = .systemFont(ofSize: 16, weight: .medium)
        textColor = .appBlack
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setTitle(_ title: String) {
        text = title
    }
}
