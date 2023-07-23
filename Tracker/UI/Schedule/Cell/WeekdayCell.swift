import UIKit

final class WeekdayCell: UITableViewCell {
    
    // MARK: - UI
    
    private lazy var weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .appBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weekdaySwitch: UISwitch = {
        let weekdaySwitch = UISwitch()
        weekdaySwitch.onTintColor = .appBlue
        weekdaySwitch.addTarget(self, action: #selector(weekdaySwitchTapped), for: .valueChanged)
        weekdaySwitch.translatesAutoresizingMaskIntoConstraints = false
        return weekdaySwitch
    }()
    
    private var currentDay: WeekDay?
    weak var delegate: WeekdayCellDelegate?
    
    // MARK: - Init
    
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
        selectionStyle = .none
        contentView.addSubview(weekdayLabel)
        contentView.addSubview(weekdaySwitch)
    }
    
    func configure(with day: WeekDay) {
        currentDay = day
        weekdayLabel.text = day.title
    }
    
    func isSelectedDay() {
        weekdaySwitch.setOn(true, animated: false)
    }
    
    // MARK: - Action
    
    @objc
    private func weekdaySwitchTapped() {
        guard let currentDay else { return }
        if weekdaySwitch.isOn {
            delegate?.didSelectDay(currentDay)
        } else {
            delegate?.didDeselectDay(currentDay)
        }
    }
}

// MARK: - Setting Constraints

extension WeekdayCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            weekdayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weekdayLabel.trailingAnchor.constraint(equalTo: weekdaySwitch.leadingAnchor, constant: -16),
            weekdayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            weekdaySwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            weekdaySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            weekdaySwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22)
        ])
    }
}

