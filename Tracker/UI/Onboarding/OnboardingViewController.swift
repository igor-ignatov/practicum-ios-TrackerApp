import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - UI
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .appBlack
        pageControl.pageIndicatorTintColor = .appBlack.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var endOnboardingButton: AppButton = {
        let button = AppButton(title: "Вот это технологии!", height: 60)
        button.addTarget(self, action: #selector(endOnboardingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    private lazy var pages: [UIViewController] = {
        let firstOnboardingViewController = FirstOnboarding()
        let secondOnboardingViewController = SecondOnboarding()
        return [firstOnboardingViewController, secondOnboardingViewController]
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setDelegates()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.addSubview(pageControl)
        view.addSubview(endOnboardingButton)
        
        if let first = pages.first {
            setViewControllers(
                [first],
                direction: .forward,
                animated: true
            )
        }
    }
    
    private func setDelegates() {
        dataSource = self
        delegate = self
    }
    
    // MARK: - Actions
    
    @objc
    private func endOnboardingButtonTapped() {
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = AppTabBarController()
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        var previousIndex = viewControllerIndex - 1
        if previousIndex < 0 { previousIndex = pages.count - 1 }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        var nextIndex = viewControllerIndex + 1
        if nextIndex == pages.count { nextIndex = 0 }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

// MARK: - Setting Constraints

extension OnboardingViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            endOnboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            endOnboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            endOnboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            pageControl.bottomAnchor.constraint(equalTo: endOnboardingButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
