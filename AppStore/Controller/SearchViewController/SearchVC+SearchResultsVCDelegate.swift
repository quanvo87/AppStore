extension SearchViewController: SearchResultsVCDelegate {
    func controller(_ controller: SearchResultsViewController, didSelectSearchPreview searchPreview: String) {
        navigationItem.searchController?.searchBar.text = searchPreview
        navigationItem.searchController?.searchBar.endEditing(true)
    }

    func controller(_ controller: SearchResultsViewController, didStartNewSearch query: String) {
        recentSearches = [query] + recentSearches
    }
}
