import UIKit

class AppDetailViewController: UIViewController {
    private let tableView = UITableView()
    private let app: App
    private let imageLoader: ImageLoading

    init(app: App, factory: Factory) {
        self.app = app
        imageLoader = factory.imageLoader

        super.init(nibName: nil, bundle: nil)

        tableView.dataSource = self
        tableView.separatorStyle = .none

        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.tableFooterView = UIView()

        tableView.register(
            UINib(nibName: AppDetailHeaderCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: AppDetailHeaderCell.reuseIdentifier
        )
        tableView.register(
            UINib(nibName: AppDetailRatingsCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: AppDetailRatingsCell.reuseIdentifier
        )

        tableView.reloadData()

        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppDetailViewController {
    enum Section: Int, CaseIterable {
        case header
        case ratings
        case screenshots
        case description
        case version
        case info
    }
}

extension AppDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = Section(rawValue: section), section == Section.info {
            return 5
        }
        else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailHeaderCell.reuseIdentifier) as! AppDetailHeaderCell
            cell.load(app: app, imageLoader: imageLoader)
            cell.selectionStyle = .none
            return cell
        case .ratings:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailRatingsCell.reuseIdentifier) as! AppDetailRatingsCell
            cell.load(app: app)
            cell.selectionStyle = .none
            return cell
        case .screenshots:
            break
        case .description:
            break
        case .version:
            break
        case .info:
            break
        }

        return UITableViewCell()
    }
}
