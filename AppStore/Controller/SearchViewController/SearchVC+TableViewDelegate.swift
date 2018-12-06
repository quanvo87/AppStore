import UIKit

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recentSearch = recentSearches[indexPath.row]
        navigationItem.searchController?.isActive = true
        navigationItem.searchController?.searchBar.text = recentSearch
        delegate?.controller(self, didSelectRecentSearch: recentSearch)
    }
}
