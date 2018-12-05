import UIKit

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recentSearch = recentSearches[indexPath.row]
        navigationItem.searchController?.isActive = true
        navigationItem.searchController?.searchBar.text = recentSearch
    }
}
