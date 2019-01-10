import UIKit

class Factory {
    let recentService: RecentServiceProtocol
    let newService: NewServiceProtocol
    let mostViewedService: MostViewedServiceProtocol
    let categoriesService: CategoriesServiceProtocol
    let searchService: SearchServiceProtocol
    let deleteService: DeleteServiceProtocol
    let imageLoader: ImageLoading

    init(recentService: RecentServiceProtocol = URLSession.shared,
         newService: NewServiceProtocol = URLSession.shared,
         mostViewedService: MostViewedServiceProtocol = URLSession.shared,
         categoriesService: CategoriesServiceProtocol = URLSession.shared,
         searchService: SearchServiceProtocol = SearchService(urlSession: .shared),
         deleteService: DeleteServiceProtocol = URLSession.shared,
         imageLoader: ImageLoading = ImageLoader(urlSession: .shared)) {
        self.recentService = recentService
        self.newService = newService
        self.mostViewedService = mostViewedService
        self.categoriesService = categoriesService
        self.searchService = searchService
        self.deleteService = deleteService
        self.imageLoader = imageLoader
    }

    func makeTabBarController() -> UITabBarController {
        let recentVC = RecentViewController(factory: self)
        recentVC.tabBarItem = UITabBarItem(title: "Recent", image: UIImage(named: "recent"), tag: 0)

        let newVC = NewViewController(factory: self)
        newVC.tabBarItem = UITabBarItem(title: "New", image: UIImage(named: "new"), tag: 1)

        let popularVC = MostViewedViewController(factory: self)
        popularVC.tabBarItem = UITabBarItem(title: "Most Viewed", image: UIImage(named: "most-viewed"), tag: 2)

        let categoriesVC = CategoriesViewController(factory: self)
        categoriesVC.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(named: "categories"), tag: 3)

        let searchVC = SearchViewController(factory: self)
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)

        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.viewControllers = [recentVC, newVC, popularVC, categoriesVC, searchVC].map { controller in
            let navController = UINavigationController(rootViewController: controller)
            controller.view.backgroundColor = .white
            controller.navigationController?.navigationBar.barTintColor = .white
            return navController
        }

        return tabBarController
    }

    func makeAppDetailViewController(app: App) -> AppDetailViewController {
        return AppDetailViewController(app: app, factory: self)
    }

    func makeCategoryViewController(category: String) -> CategoryViewController {
        return CategoryViewController(category: category, factory: self)
    }
}
