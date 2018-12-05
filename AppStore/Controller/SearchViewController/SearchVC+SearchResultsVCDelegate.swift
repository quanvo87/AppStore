extension SearchViewController: SearchResultsViewControllerDelegate {
    func controller(_ controller: SearchResultsViewController, didSelectSearchResult searchResult: String) {
        search(query: searchResult)
    }
}
