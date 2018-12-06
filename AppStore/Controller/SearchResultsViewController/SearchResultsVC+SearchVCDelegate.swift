extension SearchResultsViewController: SearchVCDelegate {
    func controller(_ controller: SearchViewController, didSelectRecentSearch recentSearch: String) {
        search(query: recentSearch, saveSearch: false)
    }
}
