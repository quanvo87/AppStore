import UIKit

class MostViewedViewController: UIViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let factory: Factory

    init(factory: Factory) {
        self.factory = factory

        super.init(nibName: nil, bundle: nil)

        navigationItem.title = "Most Viewed Apps"

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

        let deleteDatabaseButton = UIBarButtonItem(
            image: UIImage(named: "delete-db")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(deleteDatabase)
        )
        navigationItem.rightBarButtonItem = deleteDatabaseButton

        getData()
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
        factory.mostViewedService.getMostViewedApps { [weak self] result in
            DispatchQueue.main.async {
                aiView.removeFromSuperview()
                self?.refreshControl.endRefreshing()
            }
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Getting Most Viewed Apps", message: error.localizedDescription)
            case .success(let apps):
                self?.apps = apps
            }
        }
    }

    @objc func deleteDatabase() {
        showAlert(title: "Delete Database?", message: nil) { [weak self] _ in
            guard let `self` = self else {
                return
            }
            let aiView = self.view.showActivityIndicator()
            self.factory.deleteService.deleteDatabase { error in
                DispatchQueue.main.async {
                    aiView.removeFromSuperview()
                }
                if let error = error {
                    self.showAlert(title: "Error Deleting Database", message: error.localizedDescription)
                } else {
                    self.showAlert(title: "Delete Database Successful", message: nil)
                    self.getData()
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MostViewedViewController: UITableViewDataSource {
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

extension MostViewedViewController: UITableViewDelegate {
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
        return apps.isEmpty ? "No apps have been viewed yet." : nil
    }
}
