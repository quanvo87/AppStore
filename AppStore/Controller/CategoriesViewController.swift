import UIKit

class CategoriesViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        navigationItem.title = "Categories"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
