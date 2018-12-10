import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(action)
        if handler != nil {
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alert.addAction(cancel)
        }
        present(alert, animated: true, completion: nil)
    }
}
