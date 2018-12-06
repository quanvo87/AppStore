import UIKit

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingSearchResults ? searchResults.count : searchPreviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowingSearchResults {
            let cell = tableView.dequeueReusableCell(withIdentifier: AppSearchCell.reuseIdentifier) as! AppSearchCell
            let searchResult = searchResults[indexPath.row]
            cell.load(app: searchResult, imageLoader: imageLoader)
            return cell
        } else {
            let cell = UITableViewCell()
            let searchPreview = searchPreviews[indexPath.row]
            cell.textLabel?.text = searchPreview
            return cell
        }
    }
}
