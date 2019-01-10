import Foundation

extension String {
    private static let byteCountFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        return formatter
    }()

    private static let dateFormatterLong: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    private static let dateFormatterShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    var toMB: String? {
        guard let byteCount = Int64(self) else {
            return nil
        }
        return String.byteCountFormatter.string(fromByteCount: byteCount)
    }

    var toShortenedDate: String? {
        guard let date = String.dateFormatterLong.date(from: self) else {
            return nil
        }
        return String.dateFormatterShort.string(from: date)
    }
}
