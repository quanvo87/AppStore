import UIKit

extension UIView {
    func showActivityIndicator() -> UIView {
        let view = UIView(frame: bounds)
        view.isUserInteractionEnabled = false

        let aiView = UIActivityIndicatorView(style: .gray)
        aiView.center = center
        aiView.startAnimating()

        DispatchQueue.main.async {
            view.addSubview(aiView)
            self.addSubview(view)
        }

        return view
    }
}
