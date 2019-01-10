import UIKit

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingSearchResults ? searchResults.count : searchPreviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowingSearchResults {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LargeAppCell.reuseIdentifier
                ) as? LargeAppCell else {
                    assertionFailure()
                    return LargeAppCell()
            }
            let searchResult = searchResults[indexPath.row]
            cell.load(app: searchResult, factory: factory)
            return cell
        } else {
            let cell = UITableViewCell()
            let searchPreview = searchPreviews[indexPath.row]
            cell.textLabel?.text = searchPreview
            return cell
        }
    }
}
