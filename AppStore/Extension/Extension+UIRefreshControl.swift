import UIKit

extension UIRefreshControl {
    func configure(target: Any?, action: Selector) {
        addTarget(target, action: action, for: .valueChanged)
        attributedTitle = NSAttributedString(
            string: "Pull to refresh",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
}
