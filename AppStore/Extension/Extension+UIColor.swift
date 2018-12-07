import UIKit

extension UIColor {
    static var tintColor: UIColor {
        return UIApplication.shared.keyWindow?.rootViewController?.view.tintColor ?? UIColor()
    }
}
