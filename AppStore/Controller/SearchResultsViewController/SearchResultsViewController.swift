import UIKit

// todo: maybe add method here for passing back an app was tapped
// parent view can push app detail vc onto its nav ctrl
protocol SearchResultsVCDelegate: AnyObject {
    func controller(_ controller: SearchResultsViewController, didSelectSearchPreview searchPreview: String)
    func controller(_ controller: SearchResultsViewController, didStartNewSearch query: String)
    func controller(_ controller: SearchResultsViewController, didSelectApp app: App)
}

class SearchResultsViewController: UIViewController {
    let tableView = UITableView()
    let searchService: SearchServiceProtocol
    let factory: Factory
    let imageLoader: ImageLoading
    weak var delegate: SearchResultsVCDelegate?

    init(searchService: SearchServiceProtocol, factory: Factory, delegate: SearchResultsVCDelegate) {
        self.searchService = searchService
        self.factory = factory
        self.imageLoader = factory.imageLoader
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.tableFooterView = UIView()
        tableView.register(
            UINib(nibName: LargeAppCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: LargeAppCell.reuseIdentifier
        )

        view.addSubview(tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var searchPreviews = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    var searchResults = [App]() {
        didSet {
            tableView.reloadData()
        }
    }

    var isShowingSearchResults = false {
        didSet {
            if isShowingSearchResults {
                tableView.separatorStyle = .none
            } else {
                tableView.separatorStyle = .singleLine
            }
            tableView.reloadData()
        }
    }

    func search(query: String, saveSearch: Bool) {
        if saveSearch {
            delegate?.controller(self, didStartNewSearch: query)
        }
        isShowingSearchResults = true
        searchService.search(query: query, saveSearch: saveSearch) { [weak self] result in
            guard let `self` = self else {
                return
            }
            switch result {
            case .failure(let error):
                self.showAlert(title: "Search Error", message: error.localizedDescription)
            case .success(let results):
                self.searchResults = results
            }
        }
    }
}
