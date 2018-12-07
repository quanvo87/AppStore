import UIKit

class AppDetailInfoCell: UITableViewCell {
    static let reuseIdentifier = String(describing: AppDetailInfoCell.self)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    func load(title: String, detail: String) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }
}
