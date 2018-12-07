import UIKit

class Factory {
    private let urlSession: URLSession
    private let user: User
    let authService: AuthServiceProtocol
    let searchService: SearchServiceProtocol
    
    init(user: User,
         authService: AuthServiceProtocol = AuthService(),
         urlSession: URLSession = .shared) {
        self.user = user
        self.authService = authService
        self.urlSession = urlSession
        searchService = SearchService(urlSession: urlSession, uid: user.uid)
    }

    var newService: NewServiceProtocol {
        return urlSession
    }

    var popularService: PopularServiceProtocol {
        return urlSession
    }

    var categoriesService: CategoriesServiceProtocol {
        return urlSession
    }

    var imageLoader: ImageLoading {
        return urlSession
    }
    
    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        
        let newVC = NewViewController(factory: self)
        newVC.tabBarItem = UITabBarItem(title: "New", image: UIImage(named: "new"), tag: 0)
        
        let popularVC = PopularViewController(factory: self)
        popularVC.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(named: "popular"), tag: 1)
        
        let categoriesVC = CategoriesViewController(factory: self)
        categoriesVC.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(named: "categories"), tag: 2)
        
        let searchVC = SearchViewController(factory: self)
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
    
    func makeAppDetailViewController(app: App) -> AppDetailViewController {
        return AppDetailViewController(app: app, factory: self)
    }
}
