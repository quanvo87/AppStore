import UIKit

protocol SearchVCDelegate: AnyObject {
    func controller(_ controller: SearchViewController, didSelectRecentSearch recentSearch: String)
}

class SearchViewController: UIViewController {
    let tableView = UITableView()
    let factory: Factory
    weak var delegate: SearchVCDelegate?
    
    init(factory: Factory) {
        self.factory = factory
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = "Search"
        
        let searchResultsController = SearchResultsViewController(factory: factory, delegate: self)
        delegate = searchResultsController
        
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.placeholder = "App Store"
        searchController.searchResultsUpdater = searchResultsController
        searchController.searchBar.delegate = searchResultsController
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)

        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    var recentSearches = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @objc private func getData() {
        let ai = view.showActivityIndicator()
        factory.searchService.getRecentSearches { [weak self] result in
            DispatchQueue.main.async {
                ai.removeFromSuperview()
            }
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Getting Recent Searches", message: error.localizedDescription)
            case .success(let recentSearches):
                self?.recentSearches = recentSearches
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
