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

        factory.categoriesService.getCategories { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Getting App Categories", message: error.localizedDescription)
            case .success(let categories):
                self?.categories = categories
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var categories = [String]() {
        didSet {
            tableView.reloadData()
        }
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
        let vc = CategoryViewController(category: category, factory: factory)
        navigationController?.pushViewController(vc, animated: true)
    }
}
