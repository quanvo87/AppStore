import UIKit

class AppSearchCell: UITableViewCell {
    static let reuseIdentifier = String(describing: AppSearchCell.self)

    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var screenshot1imageView: UIImageView!
    @IBOutlet weak var screenshot2imageView: UIImageView!
    @IBOutlet weak var screenshot3imageView: UIImageView!

    private var appIconUrl: String?
    private var screenshot1Url: String?
    private var screenshot2Url: String?
    private var screenshot3Url: String?

    func load(app: App, imageLoader: ImageLoading) {
        appNameLabel.text = app.trackName
        sellerNameLabel.text = app.sellerName
        ratingsLabel.text = String(app.averageUserRating)
        priceLabel.text = app.formattedPrice

        appIconImageView.image = nil
        appIconUrl = app.artworkUrl60
        imageLoader.getImage(forUrl: app.artworkUrl60) { [weak self] result in
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

        screenshot1imageView.image = nil
        if screenshotUrls.count > 0 {
            let url = screenshotUrls[0]
            screenshot1Url = url
            imageLoader.getImage(forUrl: url) { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let tuple):
                    if tuple.0 == self?.screenshot1Url {
                        self?.screenshot1imageView.image = tuple.1
                    }
                }
            }
        }

        screenshot2imageView.image = nil
        if screenshotUrls.count > 1 {
            let url = screenshotUrls[1]
            screenshot2Url = url
            imageLoader.getImage(forUrl: url) { [weak self] result in
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

        screenshot3imageView.image = nil
        if screenshotUrls.count > 2 {
            let url = screenshotUrls[2]
            screenshot3Url = url
            imageLoader.getImage(forUrl: url) { [weak self] result in
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
