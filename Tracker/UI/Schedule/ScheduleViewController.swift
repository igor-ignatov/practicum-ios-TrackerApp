import UIKit

protocol ScheduleDelegate: AnyObject {
    func didSelectDays(_ days: Set<WeekDay>)
}

final class ScheduleViewController: UIViewController {
    
    // MARK: - Delegate
    
    weak var delegate: ScheduleDelegate?
    
    // MARK: - UI
    
    private lazy var titleLabel = AppTitleLabel(title: "Расписание")
    
    private lazy var weekDaysTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .appGray
        tableView.registerReusableCell(cellType: WeekdayCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var doneButton: AppButton = {
        let button = AppButton(title: "Готово")
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    private var selectedDays: Set<WeekDay> = []
    
    // MARK: - Life Cycle
    
    init(selectedDays: Set<WeekDay>) {
        self.selectedDays = selectedDays
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setDelegates()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(titleLabel)
        view.addSubview(weekDaysTableView)
        view.addSubview(doneButton)
    }
    
    private func setDelegates() {
        weekDaysTableView.delegate = self
        weekDaysTableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @objc
    private func doneButtonTapped() {
        delegate?.didSelectDays(self.selectedDays)
        dismiss(animated: true)
    }
}

// MARK: - WeekdayCellDelegate

extension ScheduleViewController: WeekdayCellDelegate {
    func didSelectDay(_ day: WeekDay) {
        selectedDays.insert(day)
    }
    
    func didDeselectDay(_ day: WeekDay) {
        selectedDays.remove(day)
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: WeekdayCell.self)
        let currentDay = WeekDay.allCases[indexPath.row]
        cell.delegate = self
        cell.configure(with: currentDay)
        if selectedDays.contains(currentDay) {
            cell.isSelectedDay()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if indexPath.row == WeekDay.allCases.count - 1 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
}

// MARK: - Setting Constraints

extension ScheduleViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            weekDaysTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            weekDaysTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            weekDaysTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            weekDaysTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -16),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

