import UIKit

class LargeAppCell: UITableViewCell {
    static let reuseIdentifier = String(describing: LargeAppCell.self)

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var screenshot1imageView: UIImageView!
    @IBOutlet weak var screenshot2imageView: UIImageView!
    @IBOutlet weak var screenshot3imageView: UIImageView!

    private var appIconUrl: String?
    private var screenshot1Url: String?
    private var screenshot2Url: String?
    private var screenshot3Url: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        appIconImageView.layer.cornerRadius = 15
        appIconImageView.clipsToBounds = true
        priceButton.layer.cornerRadius = 15
        priceButton.isUserInteractionEnabled = false
        screenshot1imageView.layer.cornerRadius = 10
        screenshot1imageView.clipsToBounds = true
        screenshot1imageView.contentMode = .scaleAspectFill
        screenshot2imageView.layer.cornerRadius = 10
        screenshot2imageView.clipsToBounds = true
        screenshot2imageView.contentMode = .scaleAspectFill
        screenshot3imageView.layer.cornerRadius = 10
        screenshot3imageView.clipsToBounds = true
        screenshot3imageView.contentMode = .scaleAspectFill
    }

    func load(app: App, factory: Factory) {
        appNameLabel.text = app.trackName
        sellerNameLabel.text = app.sellerName
        ratingsLabel.text = String(app.averageUserRating) + " ✩ (" + String(app.userRatingCount) + ")"

        priceButton.setTitle(app.formattedPrice, for: .normal)
        priceButton.isHidden = app.formattedPrice == ""

        appIconImageView.image = nil
        screenshot1imageView.image = nil
        screenshot2imageView.image = nil
        screenshot3imageView.image = nil

        let imageLoader = factory.imageLoader

        appIconUrl = app.artworkUrl100
        imageLoader.getImage(forUrl: app.artworkUrl100) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tuple):
                if tuple.0 == self?.appIconUrl {
                    self?.appIconImageView.image = tuple.1
                }
            }
        }

        let screenshotUrls = app.screenshotUrls

        if screenshotUrls.count > 0 {
            let url = screenshotUrls[0]
            screenshot1Url = url
            imageLoader.getImage(forUrl: url) { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let tuple):
                    if tuple.0 == self?.screenshot1Url {
                        let image1 = tuple.1
                        self?.screenshot1imageView.image = image1
                        if image1.size.width > image1.size.height {
                            self?.screenshot2imageView.isHidden = true
                            self?.screenshot3imageView.isHidden = true
                        } else {
                            self?.screenshot2imageView.isHidden = false
                            if screenshotUrls.count > 1 {
                                let url = screenshotUrls[1]
                                self?.screenshot2Url = url
                                imageLoader.getImage(forUrl: url) { result in
                                    switch result {
                                    case .failure(let error):
                                        print(error)
                                    case .success(let tuple):
                                        if tuple.0 == self?.screenshot2Url {
                                            self?.screenshot2imageView.image = tuple.1
                                        }
                                    }
                                }
                            }
                            self?.screenshot3imageView.isHidden = false
                            if screenshotUrls.count > 2 {
                                let url = screenshotUrls[2]
                                self?.screenshot3Url = url
                                imageLoader.getImage(forUrl: url) { result in
                                    switch result {
                                    case .failure(let error):
                                        print(error)
                                    case .success(let tuple):
                                        if tuple.0 == self?.screenshot3Url {
                                            self?.screenshot3imageView.image = tuple.1
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
