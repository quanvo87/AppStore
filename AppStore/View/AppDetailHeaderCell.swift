import UIKit

class AppDetailHeaderCell: UITableViewCell {
    static let reuseIdentifier = String(describing: AppDetailHeaderCell.self)

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!

    private var appIconUrl: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        appIconImageView.layer.cornerRadius = 25
        appIconImageView.clipsToBounds = true
        appIconImageView.contentMode = .scaleAspectFill
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        priceButton.layer.cornerRadius = 13
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.backgroundColor = UIColor.tint
    }

    func load(app: App, factory: Factory) {
        appNameLabel.text = app.trackName
        sellerNameLabel.text = app.sellerName
        priceButton.setTitle(app.formattedPrice, for: .normal)
        priceButton.isHidden = app.formattedPrice == ""

        appIconImageView.image = nil
        appIconUrl = app.artworkUrl512
        factory.imageLoader.getImage(forUrl: app.artworkUrl512) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tuple):
                if tuple.0 == self?.appIconUrl {
                    self?.appIconImageView.image = tuple.1
                }
            }
        }
    }
}
