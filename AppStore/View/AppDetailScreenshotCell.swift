import UIKit

class AppDetailScreenshotCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: AppDetailScreenshotCell.self)

    @IBOutlet weak var screenshotImageView: UIImageView!

    private var screenshotUrl: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        screenshotImageView.layer.cornerRadius = 15
        screenshotImageView.clipsToBounds = true
        screenshotImageView.contentMode = .scaleAspectFill
    }

    func load(screenshotUrl: String, factory: Factory) {
        screenshotImageView.image = nil
        self.screenshotUrl = screenshotUrl
        factory.imageLoader.getImage(forUrl: screenshotUrl) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tuple):
                if tuple.0 == self?.screenshotUrl {
                    self?.screenshotImageView.image = tuple.1
                }
            }
        }
    }
}
