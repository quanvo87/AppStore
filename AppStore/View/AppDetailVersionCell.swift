import UIKit

class AppDetailVersionCell: UITableViewCell {
    static let reuseIdentifier = String(describing: AppDetailVersionCell.self)

    @IBOutlet weak var whatsNewLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var releaseNotesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        whatsNewLabel.font = UIFont.boldSystemFont(ofSize: 22)
    }

    func load(app: App) {
        versionLabel.text = "Version " + app.version
        releaseDateLabel.text = app.currentVersionReleaseDate.toShortenedDate
        releaseNotesLabel.text = app.releaseNotes
        releaseNotesLabel.sizeToFit()
    }
}
