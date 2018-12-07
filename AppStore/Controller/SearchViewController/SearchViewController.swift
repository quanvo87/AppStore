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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }

        getRecentSearches()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var recentSearches = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    func getRecentSearches() {
        factory.searchService.getRecentSearches { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Getting Recent Searches", message: error.localizedDescription)
            case .success(let recentSearches):
                self?.recentSearches = recentSearches
            }
        }
    }
}
