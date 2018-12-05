import UIKit

class NewViewController: UIViewController {
    private var networkService: NewNetworkService!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Newest Apps"
        setupNavigationBar()
    }

    static func make(networkService: NewNetworkService) -> NewViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "NewViewController") as! NewViewController
        vc.networkService = networkService
        return vc
    }
}

private extension NewViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
