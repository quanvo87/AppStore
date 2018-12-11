import UIKit

protocol SearchResultsVCDelegate: AnyObject {
    func controller(_ controller: SearchResultsViewController, didSelectSearchPreview searchPreview: String)
    func controller(_ controller: SearchResultsViewController, didStartNewSearch query: String)
    func controller(_ controller: SearchResultsViewController, didSelectApp app: App)
}

class SearchResultsViewController: UIViewController {
    let tableView = UITableView()
    let factory: Factory
    weak var delegate: SearchResultsVCDelegate?
    
    init(factory: Factory, delegate: SearchResultsVCDelegate) {
        self.factory = factory
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
        let ai = view.showActivityIndicator()
        factory.searchService.search(query: query, saveSearch: saveSearch) { [weak self] result in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                ai.removeFromSuperview()
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
