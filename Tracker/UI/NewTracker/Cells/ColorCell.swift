import UIKit

final class ColorCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 3, y: 3, width: 46, height: 46)
        view.layer.cornerRadius = 8
        view.backgroundColor = .appWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        view.layer.cornerRadius = 8
        view.backgroundColor = .appWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            borderView.backgroundColor = isSelected ? colorView.backgroundColor?.withAlphaComponent(0.3) : .clear
        }
    }
    
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
        contentView.addSubview(borderView)
        contentView.addSubview(whiteView)
        contentView.addSubview(colorView)
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
}

// MARK: - Settings Constraints

extension ColorCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
