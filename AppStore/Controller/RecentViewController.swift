import UIKit

class RecentViewController: UIViewController {
    private let tableView = UITableView()
    private let factory: Factory
    
    init(factory: Factory) {
        self.factory = factory
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = "Recently Searched Apps"
        
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

        let logoutButton = UIBarButtonItem(
            image: UIImage(named: "user")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(logout)
        )
        navigationItem.rightBarButtonItem = logoutButton
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        factory.recentService.getAppsBySearchDate(offset: 0) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Getting Apps By Search Date", message: error.localizedDescription)
            case .success(let apps):
                self?.apps = apps
            }
        }
    }
    
    var apps = [App]() {
        didSet {
            tableView.reloadData()
        }
    }

    @objc func logout() {
        showAlert(title: "Log Out", message: "Do you want to log out?") { [weak self] _ in
            self?.factory.authService.logOut()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LargeAppCell.reuseIdentifier) as! LargeAppCell
        let app = apps[indexPath.row]
        cell.load(app: app, factory: factory)
        return cell
    }
}

extension RecentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let app = apps[indexPath.row]
        let vc = factory.makeAppDetailViewController(app: app)
        navigationController?.pushViewController(vc, animated: true)
    }
}
