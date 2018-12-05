import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func controller(_ controller: SearchViewController, didGetSearchResults searchResults: [String])
}

class SearchViewController: UIViewController {
    let tableView = UITableView()

    let searchService: SearchServiceProtocol

    var searchResults = [App]()
    var recentSearches = [String]()

    weak var delegate: SearchViewControllerDelegate?

    init(searchService: SearchServiceProtocol) {
        self.searchService = searchService

        super.init(nibName: nil, bundle: nil)

        navigationItem.title = "Search"

        let searchResultsController = SearchResultsViewController(delegate: self)
        delegate = searchResultsController

        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "App Store"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
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

        searchService.getRecentSearches { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Getting Recent Searches", message: error.localizedDescription)
            case .success(let recentSearches):
                self?.recentSearches = recentSearches
                self?.tableView.reloadData()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func search(query: String) {
        searchService.search(query: query, saveSearch: true) { [weak self] result in
            guard let `self` = self else {
                return
            }
            switch result {
            case .failure(let error):
                self.showAlert(title: "Search Error", message: error.localizedDescription)
            case .success(let results):
                self.searchResults = results
                self.tableView.reloadData()
            }
        }
    }
}
