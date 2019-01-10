import UIKit

extension UIColor {
    static var tint: UIColor {
        return UIApplication.shared.keyWindow?.rootViewController?.view.tintColor ?? UIColor()
    }
}
