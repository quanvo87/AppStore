import UIKit

class SearchViewController: UIViewController {
    private let searchService: SearchServiceProtocol
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()

    let test = ["pikachu", "bulbasaur", "squirtle", "charmander", "pikachu"]

    init(searchService: SearchServiceProtocol) {
        self.searchService = searchService

        super.init(nibName: nil, bundle: nil)

        navigationItem.title = "Search"

        searchController.searchBar.placeholder = "App Store"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.dataSource = self
        //        tableView.delegate = self
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Searches"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let pokemon = test[indexPath.row]

        cell.textLabel?.text = pokemon
        cell.textLabel?.textColor = view.tintColor

        return cell
    }
}
