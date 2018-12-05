import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func controller(_ controller: SearchResultsViewController, didSelectSearchResult searchResult: String)
}

class SearchResultsViewController: UIViewController {
    private let tableView = UITableView()
    private var searchResults = [String]()
    private weak var delegate: SearchResultsViewControllerDelegate?

    init(delegate: SearchResultsViewControllerDelegate?) {
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)

        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultsViewController: SearchViewControllerDelegate {
    func controller(_ controller: SearchViewController, didGetSearchResults searchResults: [String]) {
        self.searchResults = searchResults
        tableView.reloadData()
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult
        return cell
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = searchResults[indexPath.row]
        delegate?.controller(self, didSelectSearchResult: searchResult)
    }
}
