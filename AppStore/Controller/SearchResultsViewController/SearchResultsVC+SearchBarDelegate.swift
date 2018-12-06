import UIKit

extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" else {
            isShowingSearchResults = false
            return
        }
        search(query: text, saveSearch: true)
    }
}
