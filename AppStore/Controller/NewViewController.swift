import UIKit

class NewViewController: UIViewController {
    private let newService: NewServiceProtocol

    init(newService: NewServiceProtocol) {
        self.newService = newService

        super.init(nibName: nil, bundle: nil)

        navigationItem.title = "Newest Apps"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
