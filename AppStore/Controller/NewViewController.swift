import UIKit

class NewViewController: UIViewController {
    let tableView = UITableView()
    let newService: NewServiceProtocol
    let imageLoader: ImageLoading
    
    init(newService: NewServiceProtocol, imageLoader: ImageLoading) {
        self.newService = newService
        self.imageLoader = imageLoader
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = "Newest Apps"
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        newService.getNewestApps(offset: 0) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error Getting Newest Apps", message: error.localizedDescription)
            case .success(let apps):
                self?.apps = apps
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var apps = [App]() {
        didSet {
            tableView.reloadData()
        }
    }
}

extension NewViewController: UITableViewDataSource {
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

extension NewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
