import UIKit

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Searches"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let recentSearch = recentSearches[indexPath.row]

        cell.textLabel?.text = recentSearch
        cell.textLabel?.textColor = view.tintColor

        return cell
    }
}
