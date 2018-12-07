import UIKit

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isShowingSearchResults ? 300 : 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isShowingSearchResults {
            let app = searchResults[indexPath.row]
            delegate?.controller(self, didSelectApp: app)
        } else {
            let searchPreview = searchPreviews[indexPath.row]
            delegate?.controller(self, didSelectSearchPreview: searchPreview)
            search(query: searchPreview, saveSearch: true)
        }
    }
}
