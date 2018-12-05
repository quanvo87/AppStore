import UIKit

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        searchService.search(query: text, saveSearch: false) { [weak self] result in
            guard let `self` = self else {
                return
            }
            switch result {
            case .failure(let error):
                self.showAlert(title: "Search Error", message: error.localizedDescription)
            case .success(let results):
                let resultNames = results.map { $0.trackName }
                self.delegate?.controller(self, didGetSearchResults: resultNames)
            }
        }
    }
}
