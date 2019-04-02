import UIKit

class AppDetailDescriptionCell: UITableViewCell {
    static let reuseIdentifier = String(describing: AppDetailDescriptionCell.self)

    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        moreButton.isUserInteractionEnabled = false
    }

    func load(description: String, expand: Bool) {
        appDescriptionLabel.text = description
        appDescriptionLabel.numberOfLines = expand ? 0 : 3
        appDescriptionLabel.sizeToFit()

        moreButton.isHidden = !appDescriptionLabel.isTextTruncated || expand

        isUserInteractionEnabled = !expand
    }
}
