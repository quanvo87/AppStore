import UIKit

class AppDetailScreenshotsCell: UITableViewCell {
    static let reuseIdentifier = String(describing: AppDetailScreenshotsCell.self)

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    private var factory: Factory?
    private var screenshotUrls = [String]()
    private var url: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: AppDetailScreenshotCell.reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: AppDetailScreenshotCell.reuseIdentifier
        )
    }

    func load(screenshotUrls: [String], factory: Factory) {
        self.screenshotUrls = screenshotUrls
        self.factory = factory

        guard !screenshotUrls.isEmpty else {
            return
        }

        let url = screenshotUrls[0]
        self.url = url

        let imageLoader = factory.imageLoader
        imageLoader.getImage(forUrl: url) { [weak self] result in
            guard let `self` = self else {
                return
            }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tuple):
                guard tuple.0 == self.url else {
                    return
                }
                let image = tuple.1
                let isWide = image.size.width > image.size.height
                let flowLayout = UICollectionViewFlowLayout()
                flowLayout.itemSize = isWide ? self.wideItemSize : self.tallItemSize
                flowLayout.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
                flowLayout.minimumLineSpacing = 10
                flowLayout.scrollDirection = .horizontal
                self.collectionView.collectionViewLayout = flowLayout
                self.heightConstraint.constant = isWide ? 200 : 500
                self.collectionView.reloadData()
            }
        }
    }
}

private extension AppDetailScreenshotsCell {
    var wideItemSize: CGSize {
        return .init(width: UIScreen.main.bounds.width - 60, height: 200)
    }

    var tallItemSize: CGSize {
        return .init(width: 250, height: 500)
    }
}

extension AppDetailScreenshotsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let factory = factory else {
            return UICollectionViewCell()
        }
        let screenshotUrl = screenshotUrls[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppDetailScreenshotCell.reuseIdentifier, for: indexPath) as! AppDetailScreenshotCell
        cell.load(screenshotUrl: screenshotUrl, factory: factory)
        return cell
    }
}
