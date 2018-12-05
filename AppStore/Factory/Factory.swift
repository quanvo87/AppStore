import UIKit

class Factory {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)

        let newVC = NewViewController(newService: urlSession)
        newVC.tabBarItem = UITabBarItem(title: "New", image: UIImage(named: "new"), tag: 0)

        let popularVC = PopularViewController()
        popularVC.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(named: "popular"), tag: 1)

        let categoriesVC = CategoriesViewController()
        categoriesVC.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(named: "categories"), tag: 2)

        let searchService = SearchService(urlSession: urlSession)
        let searchVC = SearchViewController(searchService: searchService)
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)

        tabBarController.viewControllers = [newVC, popularVC, categoriesVC, searchVC].map { vc in
            let navController = UINavigationController(rootViewController: vc)
            vc.setupNavigationBar()
            vc.view.backgroundColor = .white
            return navController
        }

        newVC.hideNavigationBarBorder()
        searchVC.hideNavigationBarBorder()

        return tabBarController
    }
}
