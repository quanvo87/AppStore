import UIKit

class AppDetailViewController: UIViewController {
    private let tableView = UITableView()
    private let factory: Factory
    private var app: App

    init(app: App, factory: Factory) {
        self.app = app
        self.factory = factory

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
        tableView.register(
            UINib(nibName: AppDetailScreenshotsCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: AppDetailScreenshotsCell.reuseIdentifier
        )
        tableView.register(
            UINib(nibName: AppDetailDescriptionCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: AppDetailDescriptionCell.reuseIdentifier
        )
        tableView.register(
            UINib(nibName: AppDetailVersionCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: AppDetailVersionCell.reuseIdentifier
        )
        tableView.register(
            UINib(nibName: AppDetailInfoCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: AppDetailInfoCell.reuseIdentifier
        )

        tableView.reloadData()

        view.addSubview(tableView)

        factory.mostViewedService.incrementAppViewCount(trackId: app.trackId) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let newViewCount):
                self?.app.viewCount = newViewCount
                DispatchQueue.main.async {
                    self?.tableView.reloadSections(
                        IndexSet(integer: 1),
                        with: UITableView.RowAnimation.automatic
                    )
                }
            }
        }
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
            cell.load(app: app, factory: factory)
            return cell
        case .ratings:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailRatingsCell.reuseIdentifier) as! AppDetailRatingsCell
            cell.load(app: app)
            return cell
        case .screenshots:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailScreenshotsCell.reuseIdentifier) as! AppDetailScreenshotsCell
            cell.load(screenshotUrls: app.screenshotUrls, factory: factory)
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailDescriptionCell.reuseIdentifier) as! AppDetailDescriptionCell
            cell.load(description: app.description)
            return cell
        case .version:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailVersionCell.reuseIdentifier) as! AppDetailVersionCell
            cell.load(app: app)
            return cell
        case .info:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
                cell.textLabel?.text = "Information"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailInfoCell.reuseIdentifier) as! AppDetailInfoCell
                cell.load(title: "Seller", detail: app.sellerName)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailInfoCell.reuseIdentifier) as! AppDetailInfoCell
                cell.load(title: "Size", detail: app.fileSizeBytes.toMB)
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailInfoCell.reuseIdentifier) as! AppDetailInfoCell
                cell.load(title: "Category", detail: app.primaryGenreName)
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailInfoCell.reuseIdentifier) as! AppDetailInfoCell
                cell.load(title: "Age Rating", detail: app.trackContentRating)
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
}
