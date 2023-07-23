import UIKit

final class AppTitleLabel: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        setupView(with: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(with title: String) {
        text = title
        font = .systemFont(ofSize: 16, weight: .medium)
        textColor = .appBlack
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
}
