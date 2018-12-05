struct App {
    let trackId: Int
    let trackName: String
    let artworkUrl60: String
    let sellerName: String
    let formattedPrice: String
    let averageUserRating: Double
    let userRatingCount: Int
    let trackContentRating: String
    let screenshotUrls: [String]
    let description: String
    let version: String
    let currentVersionReleaseDate: String
    let releaseNotes: String
    let fileSizeBytes: String
    let genres: [String]
    let releaseDate: String
    let viewCount: Int
}

extension App: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trackId = try container.decodeIfPresent(Int.self, forKey: .trackId) ?? 0
        trackName = try container.decodeIfPresent(String.self, forKey: .trackName) ?? ""
        artworkUrl60 = try container.decodeIfPresent(String.self, forKey: .artworkUrl60) ?? ""
        sellerName = try container.decodeIfPresent(String.self, forKey: .sellerName) ?? ""
        formattedPrice = try container.decodeIfPresent(String.self, forKey: .formattedPrice) ?? ""
        averageUserRating = try container.decodeIfPresent(Double.self, forKey: .averageUserRating) ?? 0
        userRatingCount = try container.decodeIfPresent(Int.self, forKey: .userRatingCount) ?? 0
        trackContentRating = try container.decodeIfPresent(String.self, forKey: .trackContentRating) ?? ""
        screenshotUrls = try container.decodeIfPresent([String].self, forKey: .screenshotUrls) ?? []
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        version = try container.decodeIfPresent(String.self, forKey: .version) ?? ""
        currentVersionReleaseDate = try container.decodeIfPresent(String.self, forKey: .currentVersionReleaseDate) ?? ""
        releaseNotes = try container.decodeIfPresent(String.self, forKey: .releaseNotes) ?? ""
        fileSizeBytes = try container.decodeIfPresent(String.self, forKey: .fileSizeBytes) ?? ""
        genres = try container.decodeIfPresent([String].self, forKey: .genres) ?? []
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        viewCount = try container.decodeIfPresent(Int.self, forKey: .viewCount) ?? 0
    }
}
