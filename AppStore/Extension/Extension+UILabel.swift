import UIKit

extension UILabel {
    var isTextTruncated: Bool {
        layoutIfNeeded()

        let rectBounds = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        var fullTextHeight: CGFloat?

        if attributedText != nil {
            fullTextHeight = attributedText?.boundingRect(
                with: rectBounds,
                options: .usesLineFragmentOrigin,
                context: nil).size.height
        } else {
            fullTextHeight = text?.boundingRect(
                with: rectBounds,
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: font as Any],
                context: nil).size.height
        }

        return (fullTextHeight ?? 0) > bounds.size.height
    }
}
