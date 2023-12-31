import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Delegate
    
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - UI
    
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pinnedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-pinned")
        imageView.contentMode = .center
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.text = "1 день"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .appBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .clear
        button.layer.cornerRadius = 17
        button.addTarget(
            self,
            action: #selector(doneButtonTapped),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    private var isCompletedToday: Bool = true
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    var previewView: UIView {
        wrapperView
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
        addSubview(wrapperView)
        wrapperView.addSubview(backingView)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(pinnedImageView)
        backingView.addSubview(emojiLabel)
        addSubview(counterLabel)
        addSubview(doneButton)
    }
    
    private func setCompletedButton() {
        doneButton.alpha = 0.3
        doneButton.setImage(
            UIImage(named: "icon-checkmark")?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
    }
    
    private func setUncompletedButton() {
        doneButton.alpha = 1.0
        doneButton.setImage(
            UIImage(named: "icon-plus")?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
    }
    
    func configure(
        with tracker: Tracker,
        isCompletedToday: Bool,
        completedDays: Int,
        indexPath: IndexPath
    ) {
        self.isCompletedToday = isCompletedToday
        self.trackerId = tracker.id
        self.indexPath = indexPath
        wrapperView.backgroundColor = tracker.color
        titleLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        doneButton.backgroundColor = tracker.color
        pinnedImageView.isHidden = !tracker.isPinned
        isCompletedToday ? setCompletedButton() : setUncompletedButton()
        counterLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Number of days"),
            completedDays
        )
    }
    
    // MARK: - Actions
    
    @objc
    private func doneButtonTapped() {
        guard let trackerId, let indexPath else { return }
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}

// MARK: - Setting Constraints

extension TrackerCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: topAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrapperView.heightAnchor.constraint(equalToConstant: 90),
            
            backingView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 12),
            backingView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 12),
            backingView.widthAnchor.constraint(equalToConstant: 24),
            backingView.heightAnchor.constraint(equalToConstant: 24),
            
            pinnedImageView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 12),
            pinnedImageView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -4),
            pinnedImageView.widthAnchor.constraint(equalToConstant: 24),
            pinnedImageView.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: backingView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: backingView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -12),
            
            counterLabel.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            counterLabel.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -12),
            
            doneButton.topAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: 8),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}
