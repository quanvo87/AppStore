import UIKit

class CategoryViewController: UIViewController {
    private let tableView = UITableView()
    private let categoriesService: CategoriesServiceProtocol
    private let imageLoader: ImageLoading

    init(category: String, categoriesService: CategoriesServiceProtocol, imageLoader: ImageLoading) {
        self.categoriesService = categoriesService
        self.imageLoader = imageLoader

        super.init(nibName: nil, bundle: nil)

        navigationItem.title = category

        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(
            UINib(nibName: LargeAppCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: LargeAppCell.reuseIdentifier
        )

        view.addSubview(tableView)

        categoriesService.getAppsForCategory(category) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Getting Apps", message: error.localizedDescription)
            case .success(let apps):
                self?.apps = apps
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var apps = [App]() {
        didSet {
            tableView.reloadData()
        }
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LargeAppCell.reuseIdentifier) as! LargeAppCell
        let app = apps[indexPath.row]
        cell.load(app: app, imageLoader: imageLoader)
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
