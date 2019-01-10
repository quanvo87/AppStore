import UIKit

class CategoriesViewController: UIViewController {
    private let tableView = UITableView()
    private let factory: Factory

    init(factory: Factory) {
        self.factory = factory

        super.init(nibName: nil, bundle: nil)

        navigationItem.title = "Categories"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)

        let deleteDatabaseButton = UIBarButtonItem(
            image: UIImage(named: "delete-db")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(deleteDatabase)
        )
        navigationItem.rightBarButtonItem = deleteDatabaseButton

        let aiView = view.showActivityIndicator()
        factory.categoriesService.getCategories { [weak self] result in
            DispatchQueue.main.async {
                aiView.removeFromSuperview()
            }
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Getting App Categories", message: error.localizedDescription)
            case .success(let categories):
                self?.categories = categories
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private var categories = [String]() {
        didSet {
            tableView.reloadData()
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
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let category = categories[indexPath.row]
        cell.textLabel?.text = category
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let category = categories[indexPath.row]
        let categoryVc = factory.makeCategoryViewController(category: category)
        navigationController?.pushViewController(categoryVc, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return categories.isEmpty ? "No app categories." : nil
    }
}
