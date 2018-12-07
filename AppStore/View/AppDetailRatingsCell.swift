import UIKit

class AppDetailRatingsCell: UITableViewCell {
    static let reuseIdentifier = String(describing: AppDetailRatingsCell.self)

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var contentRatingLabel: UILabel!

    func load(app: App) {
        ratingLabel.text = String(app.averageUserRating) + " ✩"
        ratingsCountLabel.text = String(app.userRatingCount) + " Ratings"
        viewCountLabel.text = String(app.viewCount)
        contentRatingLabel.text = String(app.trackContentRating)
    }
}
