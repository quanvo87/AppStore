import UIKit

extension UIView {
    func showActivityIndicator() -> UIView {
        let view = UIView(frame: bounds)
        view.isUserInteractionEnabled = false
        
        let ai = UIActivityIndicatorView(style: .gray)
        ai.center = center
        ai.startAnimating()
        
        DispatchQueue.main.async {
            view.addSubview(ai)
            self.addSubview(view)
        }
        
        return view
    }
    
    func removeFromSuperviewMainQueue() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
}
