import UIKit

class AppDetailDescriptionCell : UITableViewCell {
    static let reuseIdentifier = String(describing: AppDetailDescriptionCell.self)

    @IBOutlet weak var appDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    func load(description: String) {
        appDescriptionLabel.text = description
        appDescriptionLabel.sizeToFit()
    }
}
