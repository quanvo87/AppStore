import UIKit

class PopularViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        navigationItem.title = "Most Popular"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
