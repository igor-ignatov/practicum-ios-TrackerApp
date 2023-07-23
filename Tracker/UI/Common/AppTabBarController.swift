import UIKit

final class AppTabBarController: UITabBarController {
    
    private enum Tabs: Int {
        case trackers
        case statistic
        
        var title: String {
            switch self {
            case .trackers:
                return "Трекеры"
            case .statistic:
                return "Статистика"
            }
        }
        
        var iconName: String {
            switch self {
            case .trackers:
                return "record.circle.fill"
            case .statistic:
                return "hare.fill"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabItems()
    }
    
    private func setupTabBar() {
        let borderTop = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 0.5))
        borderTop.backgroundColor = .black.withAlphaComponent(0.3)
        tabBar.addSubview(borderTop)
    }
    
    private func setupTabItems() {
        let dataSource: [Tabs] = [
            .trackers,
            .statistic
        ]
        
        viewControllers = dataSource.map {
            switch $0 {
            case .trackers:
                return wrapInNavigationController(TrackersViewController())
            case .statistic:
                return wrapInNavigationController(StatisticViewController())
            }
        }
        
        viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            $1.tabBarItem.tag = $0
        }
    }
    
    private func wrapInNavigationController(_ vc: UIViewController) -> UINavigationController {
        UINavigationController(rootViewController: vc)
    }
}
