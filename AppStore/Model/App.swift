struct App {
    let trackId: Int
    let trackName: String
    let artworkUrl60: String
    let sellerName: String
    let formattedPrice: Double
    let averageUserRating: Double
    let userRatingCount: Int
    let trackContentRating: String
    let screenshotUrls: [String]
    let description: String
    let version: Double
    let currentVersionReleaseDate: String
    let releaseNotes: String
    let fileSizeBytes: Int
    let genres: [String]
    let releaseDate: String
}

extension App: Codable {}
