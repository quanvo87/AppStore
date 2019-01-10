import UIKit

class CategoryViewController: UIViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let category: String
    private let factory: Factory

    init(category: String, factory: Factory) {
        self.category = category
        self.factory = factory

        super.init(nibName: nil, bundle: nil)

        navigationItem.title = category + " By Search Date"

        refreshControl.configure(target: self, action: #selector(getData))

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        tableView.register(
            UINib(nibName: LargeAppCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: LargeAppCell.reuseIdentifier
        )

        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        getData()
    }

    private var apps = [App]() {
        didSet {
            tableView.reloadData()
        }
    }

    @objc private func getData() {
        let aiView = view.showActivityIndicator()
        factory.categoriesService.getAppsForCategory(category) { [weak self] result in
            DispatchQueue.main.async {
                aiView.removeFromSuperview()
                self?.refreshControl.endRefreshing()
            }
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
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: LargeAppCell.reuseIdentifier) as? LargeAppCell else {
                assertionFailure()
                return LargeAppCell()
        }
        let app = apps[indexPath.row]
        cell.load(app: app, factory: factory)
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let app = apps[indexPath.row]
        let appDetailVc = factory.makeAppDetailViewController(app: app)
        navigationController?.pushViewController(appDetailVc, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return apps.isEmpty ? "No apps in this category." : nil
    }
}
